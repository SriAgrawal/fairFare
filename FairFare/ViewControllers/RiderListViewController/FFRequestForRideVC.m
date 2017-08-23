//
//  FFRequestForRideVC.m
//  FairFareApp
//
//  Created by Suresh patel on 28/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//


#import "Header.h"
#import <GoogleMaps/GoogleMaps.h>


@interface FFRequestForRideVC ()<UIGestureRecognizerDelegate,GMSMapViewDelegate>{

    ModalDriverInfo *driverObj;
    NSTimer *timerStatus;
    NSMutableDictionary* myDict;
    BOOL isAccept;
    CLLocationCoordinate2D _source;
    CLLocationCoordinate2D _destination;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapShow;
@property (weak, nonatomic) IBOutlet UIImageView *driverImageView;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *vechileNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *vechileNumberLbl;
@property (weak, nonatomic) IBOutlet UIView *driverView;

@property(nonatomic, assign) CLLocationCoordinate2D pickupCoordinate;
@property(nonatomic, assign) CLLocationCoordinate2D destCoordinate;

@property (weak, nonatomic) IBOutlet UILabel *pickUpAddress;
@property (weak, nonatomic) IBOutlet UILabel *takeAddress;

@property (strong, nonatomic) IBOutlet UIView *markerViewPickupData;
@property (strong, nonatomic) IBOutlet UIView *markerViewTakeData;
@property (strong, nonatomic) IBOutlet GMSMapView *riderGoogleMap;

@end

@implementation FFRequestForRideVC

#pragma mark- View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
      myDict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[NSUSERDEFAULT valueForKey:@"data"]];
    driverObj = [[ModalDriverInfo alloc] init];
    
    UIImage *imageScreen;
    UIImage *imageScreenTake;
    
  [[NSBundle mainBundle] loadNibNamed:@"FFMarkerPickUP" owner:self options:nil];
    self.pickUpAddress.text =[myDict valueForKey:@"pickAddress"];
    imageScreen = [self getScreenOfGivePickView];
    
    
    
    [[NSBundle mainBundle] loadNibNamed:@"FFMarkerTake" owner:self options:nil];
    self.takeAddress.text =[myDict valueForKey:@"takeAddress"];
    imageScreenTake = [self getScreenOfGiveTakeView];
    
    
    [self setupDefaults];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatus:) name:@"refreshStatus" object:nil];
    
    [self.riderGoogleMap setDelegate:self];
    self.riderGoogleMap.myLocationEnabled = NO;
    [self.riderGoogleMap setMapType:kGMSTypeNormal];
    NSArray* sourceCoordinateArrayNew = [[myDict valueForKey:@"strPickMe"] componentsSeparatedByString: @","];
    NSArray* destinationCoordinateArrayNew = [[myDict valueForKey:@"strTakeMeTo"] componentsSeparatedByString: @","];
    
    CLLocationCoordinate2D positionPick = CLLocationCoordinate2DMake([[sourceCoordinateArrayNew firstObject] doubleValue], [[sourceCoordinateArrayNew lastObject] doubleValue]);
    GMSMarker *pickAddress = [GMSMarker markerWithPosition:positionPick];
    pickAddress.icon = [UIImage imageNamed:@"cir1"];
    pickAddress.map = self.riderGoogleMap;
    
    
    CLLocationCoordinate2D positionTake = CLLocationCoordinate2DMake([[destinationCoordinateArrayNew firstObject] doubleValue], [[destinationCoordinateArrayNew lastObject] doubleValue]);
    GMSMarker *takeAddre = [GMSMarker markerWithPosition:positionTake];
    //takeAddre.icon = imageScreenTake;
    takeAddre.icon = [UIImage imageNamed:@"cir2"];

    takeAddre.map = self.riderGoogleMap;
   
     [self addRouteOnGoogleMapWithFare:[sourceCoordinateArrayNew firstObject] :[sourceCoordinateArrayNew lastObject] andDestinationAddress:[destinationCoordinateArrayNew firstObject] :[destinationCoordinateArrayNew lastObject]];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [timerStatus invalidate];
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([NSUSERDEFAULT boolForKey:kIsRideInProgress]) {
        if ([[NSUSERDEFAULT valueForKey:@"RideID"] length]) {
            [self callWebApiToGetCurrentStatusOfLyft];
        }
        else{
            [self callWebApiToGetCurrentStatus];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timerStatus invalidate];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [timerStatus invalidate];
}


#pragma mark - Helper Method

-(UIImage *)getScreenOfGivePickView{
    
    UIGraphicsBeginImageContextWithOptions([self.markerViewPickupData bounds].size, NO, 0.0f);
    [self.markerViewPickupData drawViewHierarchyInRect:self.markerViewPickupData.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return image;
}

-(UIImage *)getScreenOfGiveTakeView{
    
    UIGraphicsBeginImageContextWithOptions([self.markerViewTakeData bounds].size, NO, 0.0f);
    [self.markerViewTakeData drawViewHierarchyInRect:self.markerViewTakeData.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)addRouteOnGoogleMapWithFare: (NSString*)SourceAddressLat :(NSString*)SourceAddressLong andDestinationAddress :(NSString*)DestinationAddLat  : (NSString*)DestinationAddLong{
    //[APPDELEGATE showHudOnWindow];
    
    NSString* saddr = [NSString stringWithFormat:@"%@,%@", SourceAddressLat, SourceAddressLong];
    NSString* daddr = [NSString stringWithFormat:@"%@,%@", DestinationAddLat, DestinationAddLong];
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true&mode=Flight",saddr,daddr]];
    
    __block NSError *error=nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    __block NSURLResponse *response = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
        NSError *e;
        
        if (responseData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&e];
            
            NSArray *routeArr = [dict objectForKeyNotNull:@"routes" expectedObj:[NSArray class]];
            if (routeArr.count>0) {
                GMSPath *path =[GMSPath pathFromEncodedPath:dict[@"routes"][0][@"overview_polyline"][@"points"]];
                NSDictionary *arr=dict[@"routes"][0][@"legs"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self drawLine:path withDataDict:arr];
                });
            }
        }
        else
        {
        }
        
    });
}

-(void)drawLine:(GMSPath *)Path withDataDict:(NSDictionary *)dict
{
    
    NSMutableArray *loc=[[NSMutableArray alloc]init];
    
    loc=[[dict valueForKey:@"start_location"]valueForKey:@"lat"];
    _source.latitude=[loc[0] doubleValue];
    
    loc=[[dict valueForKey:@"start_location"]valueForKey:@"lng"];
    _source.longitude=[loc[0] doubleValue];
    
    loc=[[dict valueForKey:@"end_location"]valueForKey:@"lat"];
    _destination.latitude=[loc[0] doubleValue];
    
    loc=[[dict valueForKey:@"end_location"]valueForKey:@"lng"];
    _destination.longitude=[loc[0] doubleValue];
    
    
    GMSPolyline *singleLine = [GMSPolyline polylineWithPath:Path];
    singleLine.strokeWidth = 5;
    
    GMSStrokeStyle *redYellow =  [GMSStrokeStyle gradientFromColor:[UIColor colorWithRed:47/255.0 green:128/255.0 blue:185/255.0 alpha:1] toColor:[UIColor colorWithRed:64/255.0 green:184/255.0 blue:151/255.0 alpha:1]];
    
    singleLine.spans = @[[GMSStyleSpan spanWithStyle:redYellow]];
    
    singleLine.map = self.riderGoogleMap;
    
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:Path];
    [self.riderGoogleMap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:100]];
    
}




#pragma mark- Class Instance Method

-(void)setupDefaults{

    NSArray* sourceCoordinateArray = [[NSUSERDEFAULT valueForKey:kStartCoordinate] componentsSeparatedByString: @","];
    NSArray* destinationCoordinateArray = [[NSUSERDEFAULT valueForKey:kEndCoordinate] componentsSeparatedByString: @","];
    
    self.pickupCoordinate = CLLocationCoordinate2DMake([[sourceCoordinateArray firstObject] doubleValue], [[sourceCoordinateArray lastObject] doubleValue]);
    self.destCoordinate = CLLocationCoordinate2DMake([[destinationCoordinateArray firstObject] doubleValue], [[destinationCoordinateArray lastObject] doubleValue]);
    
    self.driverView.hidden = YES;
    
    if ([self.ride_type length]) {
        if (self.isForBookRide)
            [self callWebApiToRequestForLyft];
        else
            [self callWebApiToGetCurrentStatusOfLyft];
    }
    else{
        if (self.isForBookRide)
            [self callWebApiToGetRideEstimate];
        else
            [self callWebApiToGetCurrentStatus];
    }
    
}

- (void)manageDriverViewDetails{
    
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    self.driverView.hidden = NO;
//    UITapGestureRecognizer *driverViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    driverViewTap.delegate = self;
//    driverViewTap.numberOfTapsRequired = 1;
//    [self.driverView addGestureRecognizer:driverViewTap];

    self.driverNameLbl.text = driverObj.strDriverName;
    self.vechileNameLbl.text = driverObj.strDriverVechileName;
    self.vechileNumberLbl.text = driverObj.strDriverVechileNo;
    self.mobileNoLbl.text = driverObj.strDriverMobileNo;
    [self.driverImageView setImageWithURL:[NSURL URLWithString:driverObj.strDriverImageInfo] placeholderImage:[UIImage imageNamed:@"user_img3"]];
}

- (void) tapGesture: (id)sender
{
    [self.view endEditing:YES];
    FFDriverViewController *objVC = [[FFDriverViewController alloc]initWithNibName:@"FFDriverViewController" bundle:nil];
    objVC.driverInfo = driverObj;
    [self.navigationController pushViewController:objVC animated:YES];
 
}
- (void) refreshStatus:(NSNotification *) notification
{
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    [self callWebApiToGetCurrentStatus];
}

//-(void)addAnnotationSrcAndDestination :(CLLocationCoordinate2D )srcCord :(CLLocationCoordinate2D)destCord andAdds:(NSString*)SourceAddress andDestinationAddress:(NSString*)DestinationAdds
//{
//    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc]init];
//    MKPointAnnotation *destAnnotation = [[MKPointAnnotation alloc]init];
//    sourceAnnotation.coordinate=srcCord;
//    destAnnotation.coordinate=destCord;
//    sourceAnnotation.title=SourceAddress;
//    destAnnotation.title=DestinationAdds;
//    [self.mapShow addAnnotation:sourceAnnotation];
//    [self.mapShow addAnnotation:destAnnotation];
//}

//- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
//    if ([mapView.annotations count] == 0) return;
//    
//    CLLocationCoordinate2D topLeftCoord;
//    topLeftCoord.latitude = -90;
//    topLeftCoord.longitude = 180;
//    
//    CLLocationCoordinate2D bottomRightCoord;
//    bottomRightCoord.latitude = 90;
//    bottomRightCoord.longitude = -180;
//    
//    for(id<MKAnnotation> annotation in mapView.annotations) {
//        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
//        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
//        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
//        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
//    }
//    
//    MKCoordinateRegion region;
//    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
//    
//    // Add a little extra space on the sides
//    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 4.5;
//    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 4.5;
//    
//    region = [mapView regionThatFits:region];
//    [mapView setRegion:region animated:YES];
//}

#pragma mark - map overlay
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0];
    renderer.lineWidth = 5.0;
    return renderer;
}

#pragma mark- IBAction Methods


- (IBAction)contactButtonAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel:%@",driverObj.strDriverMobileNo]]];

}
- (IBAction)cancelButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Warning!" message:@"Are you sure you want to cancel your ride?" andButtonsWithTitle:@[@"YES",@"NO"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if (index == 0) {
            [timerStatus invalidate];
            if ([self.ride_type length]) {
                [self callWebApiToCancelLyftRide];
            }
            else{
                [self callWebApiToCancelRide];
            }
        }
    }];
}

- (IBAction)backButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Warning!" message:@"Are you sure you want to cancel your ride?" andButtonsWithTitle:@[@"YES",@"NO"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if (index == 0) {
            [timerStatus invalidate];
            if ([self.ride_type length]) {
                [self callWebApiToCancelLyftRide];
            }
            else{
                [self callWebApiToCancelRide];
            }
        }
    }];
}

#pragma mark- Web API

// API FOR THE LYFT
-(void)callWebApiToRequestForLyft{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *originDict = [[NSMutableDictionary alloc] init];
    [originDict setValue:[NSString stringWithFormat:@"%0.6f", self.pickupCoordinate.latitude] forKey:@"lat"];
    [originDict setValue:[NSString stringWithFormat:@"%0.6f", self.pickupCoordinate.longitude] forKey:@"lng"];
    
    NSMutableDictionary *destinationDict = [[NSMutableDictionary alloc] init];
    [destinationDict setValue:[NSString stringWithFormat:@"%0.6f", self.destCoordinate.latitude] forKey:@"lat"];
    [destinationDict setValue:[NSString stringWithFormat:@"%0.6f", self.destCoordinate.longitude] forKey:@"lng"];
    
    [paramDict setValue:self.ride_type forKey:@"ride_type"];
    [paramDict setValue:originDict forKey:@"origin"];
    [paramDict setValue:destinationDict forKey:@"destination"];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:1 andApiName:@"rides" WithComptionBlock:^(id result, NSError *error) {
        if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"pending"])
        {
            [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
            [NSUSERDEFAULT setValue:[result objectForKey:@"ride_id"] forKey:@"RideID"];
            [NSUSERDEFAULT synchronize];
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Finding Drivers..." animated:YES];
            timerStatus=    [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(callWebApiToGetCurrentStatusOfLyft) userInfo:nil repeats:YES];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 400)
        {
            [AlertController title:@"" message:[result objectForKey:kErrorDescription]  andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                [self callpopToHome];
            }];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 409)
        {
            [self callWebApiToGetCurrentStatusOfLyft];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 403)
        {
            [AlertController title:@"" message:[result objectForKey:kErrorDescription] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
        }
        else
        {
            [AlertController title:@"" message:[result objectForKey:kErrorDescription]  andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
        }
    }];
    
}

-(void)callWebApiToGetCurrentStatusOfLyft{
    
    [[ISServiceHelper sharedInstance] GetAPICallWithParameter:nil AndApitype:1 AndAPIName:[NSString stringWithFormat:@"rides/%@",[NSUSERDEFAULT valueForKey:@"RideID"]] WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"pending"]) {
                
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Finding Drivers..." animated:YES];
                
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"accepted"]) {
                
                if (!isAccept) {
                    isAccept = YES;
                    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:@"Enjoy your ride." onController:self];
                }
                
              
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                driverObj = [ModalDriverInfo getDriverDetails : result];
                [self manageDriverViewDetails];
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                
            }
            
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"droppedOff"]) {
                
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT removeObjectForKey:@"RideID"];
                [NSUSERDEFAULT synchronize];
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Thankyou for choosing the Fairfare." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self callpopToHome];
                }];
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"pickedUp"]) {
                
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
//                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:@"Ride in progress." onController:self];
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"arrived"]) {
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:@"The driver has arrived or will be shortly." onController:self];
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"canceled"]) {
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT removeObjectForKey:@"RideID"];
                [NSUSERDEFAULT synchronize];
                [NSUSERDEFAULT removeObjectForKey:@"RideID"];
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"The Request has been canceled by the driver." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self callpopToHome];
                }];
                
            }
            else{
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT removeObjectForKey:@"RideID"];
                [NSUSERDEFAULT synchronize];
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"The Request was unfulfilled because no drivers were available." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self callpopToHome];
                }];
            }
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [AlertController title:@"" message:[result objectForKey:kErrorDescription] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT removeObjectForKey:@"RideID"];
                [NSUSERDEFAULT synchronize];
                [self callpopToHome];
            }];
            
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 404)
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
            [NSUSERDEFAULT removeObjectForKey:@"RideID"];
            [NSUSERDEFAULT synchronize];
            
            [AlertController title:@"" message:@"Thankyou for choosing the Fairfare." andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                [self callpopToHome];
            }];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [AlertController title:@"" message:[[[result objectForKey:kErrorDescription] firstObject] valueForKey:@"title"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT removeObjectForKey:@"RideID"];
                [NSUSERDEFAULT synchronize];
                [self callpopToHome];
            }];
        }
    }];
}

-(void)callWebApiToCancelLyftRide{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:[NSUSERDEFAULT valueForKey:@"RideID"] forKey:@"cancel_confirmation_token"];
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDic AndApiType:1 andApiName:[NSString stringWithFormat:@"rides/%@/cancel",[NSUSERDEFAULT valueForKey:@"RideID"]] WithComptionBlock:^(id result, NSError *error) {
        [AlertController title:@"" message:@"Ride has been cancelled successfully." andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
            [NSUSERDEFAULT removeObjectForKey:@"RideID"];
            [NSUSERDEFAULT synchronize];
            [self callpopToHome];
        }];
    }];
    
}


// API FOR THE UBER
-(void)callWebApiToGetRideEstimate{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.pickupCoordinate.latitude] forKey:kStart_latitude];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.pickupCoordinate.longitude] forKey:kStart_longitude];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.destCoordinate.latitude] forKey:kEnd_latitude];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.destCoordinate.longitude] forKey:kEnd_longitude];
    [paramDict setValue:self.prodict_id forKey:kProduct_id];

    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:2 andApiName:kApiRequestEstimate WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSDictionary * fairDict = [result objectForKeyNotNull:kPrice expectedObj:[NSDictionary dictionary]];
            [self callWebApiToBookARideWithFairId:[fairDict objectForKeyNotNull:kFare_id expectedObj:@""]];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
            
        }
        else
        {
            [AlertController title:@"" message:[[[result objectForKey:kError] firstObject] valueForKey:@"title"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
            
        }
    }];

}

-(void)callWebApiToBookARideWithFairId:(NSString *)fairId{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.pickupCoordinate.latitude] forKey:kStart_latitude];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.pickupCoordinate.longitude] forKey:kStart_longitude];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.destCoordinate.latitude] forKey:kEnd_latitude];
    [paramDict setValue:[NSString stringWithFormat:@"%0.6f", self.destCoordinate.longitude] forKey:kEnd_longitude];
    [paramDict setValue:fairId forKey:kFare_id];
    [paramDict setValue:self.prodict_id forKey:kProduct_id];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:2 andApiName:kApiRequest WithComptionBlock:^(id result, NSError *error) {
        if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"processing"])
        {
            [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
            [NSUSERDEFAULT synchronize];
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Finding Drivers..." animated:YES];
             timerStatus=    [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(callWebApiToGetCurrentStatus) userInfo:nil repeats:YES];
      
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                [self callpopToHome];
            }];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 409)
        {
            [self callWebApiToGetCurrentStatus];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 400)
        {
            [AlertController title:@"" message:[[[result objectForKey:kError] firstObject] valueForKey:@"title"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
        }
    }];
}

-(void)callWebApiToGetCurrentStatus{
    
    [[ISServiceHelper sharedInstance] GetAPICallWithParameter:nil AndApitype:2 AndAPIName:kApiRequestCurrent WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"processing"]) {
                
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Finding Drivers..." animated:YES];
                
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"accepted"]) {
                
                if (!isAccept) {
                    isAccept = YES;
                    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:@"Enjoy your ride." onController:self];
                }
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                driverObj = [ModalDriverInfo getDriverDetails : result];
                [self manageDriverViewDetails];
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"completed"]) {
                
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                
                if (!isAccept) {
                    isAccept = YES;
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Thankyou for choosing the Fairfare." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                        [self callpopToHome];
                    }];

                }
                
                           }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"in_progress"]) {
                
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
//                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:@"Ride in progress." onController:self];
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"arriving"]) {
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                driverObj = [ModalDriverInfo getDriverDetails : result];
                [self manageDriverViewDetails];
                [NSUSERDEFAULT setBool:YES forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:@"The driver has arrived or will be shortly." onController:self];
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"driver_canceled"]) {
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"The Request has been canceled by the driver." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self callpopToHome];
                }];
                
            }
            else if ([[[result objectForKeyNotNull:kStatus expectedObj:@""] lowercaseString] isEqualToString:@"no_drivers_available"]) {
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
                [NSUSERDEFAULT synchronize];
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"The Request was unfulfilled because no drivers were available." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    [self callpopToHome];
                }];
            }
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
            
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 404)
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
            [NSUSERDEFAULT synchronize];

            [AlertController title:@"" message:@"Thankyou for choosing the Fairfare." andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                [self callpopToHome];
            }];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [AlertController title:@"" message:[[[result objectForKey:kError] firstObject] valueForKey:@"title"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callpopToHome];
            }];
        }
    }];
}

-(void)callWebApiToCancelRide{
    [timerStatus invalidate];
   
    [[ISServiceHelper sharedInstance] DeleteAPICallWithParameters:nil AndApiType:2 andApiName:kApiRequestCurrent WithComptionBlock:^(id result, NSError *error) {
        
    [AlertController title:@"" message:@"Ride has been cancelled successfully." andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        [NSUSERDEFAULT setBool:NO forKey:kIsRideInProgress];
        [NSUSERDEFAULT synchronize];
                [self callpopToHome];
            }];
    }];
    
}
- (void)callpopToHome{
    
    
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[FFPaymentMethodViewController class]] ) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dataDismiss" object:nil];

            [self.navigationController popToViewController:viewController animated:NO];
            break;
        }
    }

}

#pragma mark- Did Receive Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
