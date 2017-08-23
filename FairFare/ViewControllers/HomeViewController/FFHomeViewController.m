//
//  FFHomeViewController.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 03/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFHomeViewController.h"
#import "ACFloatingTextField.h"
#import "FFComapreFareViewController.h"

@interface FFHomeViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,placeDelegate, UITextFieldDelegate,compareControllerDelegate> {
    CLLocationCoordinate2D coordinate;
    ModalHome *modalObj;
    UserInfo *userObj;
    NSMutableArray *dataSourceArray,*favouriteArray;
    bool isLocation,isCurrentLocation;
    UIImage *bulrNew;
    GMSCameraPosition *camera;
    
    CLLocationCoordinate2D _source;
    CLLocationCoordinate2D _destination;
}
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *familyBtn;
@property (weak, nonatomic) IBOutlet UIButton *workBtn;

@property (strong, nonatomic) IBOutlet GMSMapView *riderGoogleMap;

@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationViewHeightConstraints;
@property (strong, nonatomic) IBOutlet UIView *locationDetailView;
@property (strong, nonatomic) IBOutlet UIButton *whereToButton;
@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) IBOutlet UIView *favView;
@property (strong, nonatomic) IBOutlet UIView *officeView;
@property (strong, nonatomic) IBOutlet UIButton *pickUpButton;
@property (strong, nonatomic) IBOutlet UIButton *whereButton;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *pickUpTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *whereTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *favViewWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homeViewWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *officeViewWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationButtonXConstraints;
@property (strong, nonatomic) IBOutlet UILabel *pickUpLabel;
@property (strong, nonatomic) IBOutlet UILabel *whereToLabel;

@end


@implementation FFHomeViewController

#pragma mark- Life cycle of view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (self.isFromHistory) {
        
        if (self.modalObjNew.strTakeAddress.length && self.modalObjNew.strPickAddress) {
            [self performSelector:@selector(moveToFareNewController) withObject:nil afterDelay:0.5];

        }
        
    }
    
    modalObj =[[ModalHome alloc] init];
    userObj =[[UserInfo alloc] init];
    dataSourceArray = [[NSMutableArray alloc]init];
    favouriteArray = [[NSMutableArray alloc]init];
    [APPDELEGATE startLocation];
    [self customizeView];
    
    [self.locationDetailView setHidden:YES];
    self.locationViewHeightConstraints.constant = 50;
    [self.whereToButton setHidden:NO];
    [SSAUtility createShadowOnUIControl:self.homeView];
    [SSAUtility createShadowOnUIControl:self.officeView];
    [SSAUtility createShadowOnUIControl:self.favView];
    [SSAUtility createShadowOnUIControl:self.locationView];
    
    if (WIN_WIDTH == 320) {
        self.favViewWidthConstraints.constant = 75;
        self.officeViewWidthConstraints.constant = 95;
        self.homeViewWidthConstraints.constant = 70;
        self.navigationButtonXConstraints.constant = 0;

    }
    NSArray *tempArray = [NSArray arrayWithObjects:@"Add Home",@"Add Family", @"Add Work",nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"Home",@"3", @"Current location",nil];
    
    for (int index = 0; index < tempArray.count; index++) {
        FFHistoryInfo *info = [[FFHistoryInfo alloc]init];
        info.title = [tempArray objectAtIndex:index];
        info.image = [imageArray objectAtIndex:index];
        [favouriteArray addObject:info];
    }
    [self callGetSavePlacedApi];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusData) name:@"dataRefresh" object:nil];
   
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self checkLocationStatus];
    
    
}

#pragma mark- Helper method for view controller

-(void) refreshStatusData {
    modalObj =[[ModalHome alloc] init];
    isCurrentLocation = NO;
    [self.locationDetailView setHidden:YES];
    self.locationViewHeightConstraints.constant = 50;
    [self.whereToButton setHidden:NO];
    [self customizeView];

}


-(void)customizeView{
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate at zoom level 6.
    [_riderGoogleMap clear];
    camera = [GMSCameraPosition cameraWithLatitude:[[APPDELEGATE latitude] floatValue]
                                                            longitude:[[APPDELEGATE longitude] floatValue]
                                                                 zoom:16];
    
    [self.riderGoogleMap setDelegate:self];
    self.riderGoogleMap.myLocationEnabled = NO;
    [self.riderGoogleMap setMapType:kGMSTypeNormal];
    [self.riderGoogleMap setCamera:camera];
    
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:[[APPDELEGATE latitude] floatValue]
                                                        longitude:[[APPDELEGATE longitude] floatValue]];
    
    [self getAdrressFromLatLong:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude];

    
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([[APPDELEGATE latitude] floatValue], [[APPDELEGATE longitude] floatValue]);
    GMSMarker *london = [GMSMarker markerWithPosition:position];
    london.icon = [UIImage imageNamed:@"Current_location"];
    london.map = self.riderGoogleMap;

    
    if ([NSUSERDEFAULT boolForKey:kIsRideInProgress]) {
        
        FFRequestForRideVC *objVC = [[FFRequestForRideVC alloc]initWithNibName:@"FFRequestForRideVC" bundle:nil];
        [self.navigationController pushViewController:objVC animated:NO];
    }
}


#pragma mark - Google Map Delagate Methods

-(void) mapView:(GMSMapView *) mapView willMove:(BOOL) gesture {
    
}
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    
//    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:position.target.latitude
//                                                        longitude:position.target.longitude];
//    
//    [self getAdrressFromLatLong:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude];
}

-(void)getAdrressFromLatLong:(CGFloat)lat lon:(CGFloat)lon {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *rep = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    //    NSData *responseData = [NSURLConnection sendSynchronousRequest:request error:&amp;requestError];
    NSDictionary *JSON;
    if (rep != nil) {
        JSON = [NSJSONSerialization JSONObjectWithData:rep options: NSJSONReadingMutableContainers error:nil];
    }
    
    NSArray *resultArray = [JSON objectForKeyNotNull:@"results" expectedObj:@""];
    NSDictionary *address = [resultArray firstObject];
    if (isCurrentLocation == YES)
    {
        modalObj.strTakeAddress = [address objectForKeyNotNull:@"formatted_address" expectedObj:@""];
        modalObj.strTakeLat = [NSString stringWithFormat:@"%.03f",lat];
        modalObj.strTakeLong = [NSString stringWithFormat:@"%.03f",lon];
    }
    else
    {
        modalObj.strPickAddress = [address objectForKeyNotNull:@"formatted_address" expectedObj:@""];
        modalObj.strPickLat = [NSString stringWithFormat:@"%.03f",lat];
        modalObj.strPickLong = [NSString stringWithFormat:@"%.03f",lon];
        isCurrentLocation = YES;
    }
}


-(void)getPlaceString:(ModalHome *)obj andIsFor:(BOOL)from{
    
    CLLocationCoordinate2D location = [self getLocationFromAddressString:obj.strFullAddress];
    obj.strLatitude = [NSString stringWithFormat:@"%.03f",location.latitude];
    obj.strLongitude = [NSString stringWithFormat:@"%.03f",location.longitude];
    [self.riderGoogleMap clear];
    if (!from) {
       // [self.pickMeLocationBtn setTitle:obj.strAddress forState:UIControlStateNormal];
        self.pickUpTextField.text = obj.strFullAddress;
        modalObj.strPickLat = obj.strLatitude;
        modalObj.strPickLong = obj.strLongitude;
        modalObj.strPickAddress = obj.strFullAddress;
        modalObj.sourceCoordinate = location;
        self.locationViewHeightConstraints.constant = 100;
        [self.whereToButton setHidden:YES];
        [self.locationDetailView setHidden:NO];
        
        if (modalObj.strTakeAddress.length) {
            self.whereTextField.text = modalObj.strTakeAddress;
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([modalObj.strTakeLat doubleValue], [modalObj.strTakeLong doubleValue]);
            GMSMarker *london = [GMSMarker markerWithPosition:position];
            london.title = modalObj.strTakeAddress;
            london.icon = [UIImage imageNamed:@"Pin"];
            london.map = self.riderGoogleMap;
        }else {
            self.whereTextField.text =@"";
 
        }
        camera = [GMSCameraPosition cameraWithLatitude:[modalObj.strPickLat  floatValue]
                                             longitude:[modalObj.strPickLong floatValue]
                                                  zoom:16];
        
        [self.riderGoogleMap setCamera:camera];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([modalObj.strPickLat doubleValue], [modalObj.strPickLong doubleValue]);
        GMSMarker *markNew = [GMSMarker markerWithPosition:position];
        markNew.title = modalObj.strPickAddress;
        markNew.icon = [UIImage imageNamed:@"map_pin"];
        markNew.map = self.riderGoogleMap;
        //self.ridrGoogleMap.selectedMarker =london;

        
    }else {
        
        
        self.whereTextField.text = obj.strFullAddress;
        modalObj.strTakeLat = obj.strLatitude;
        modalObj.strTakeLong = obj.strLongitude;
        modalObj.strTakeAddress = obj.strFullAddress;
        modalObj.destinationCoordinate = location;
        self.locationViewHeightConstraints.constant = 100;
        [self.whereToButton setHidden:YES];
        [self.locationDetailView setHidden:NO];
        
        if (modalObj.strPickAddress.length) {
            self.pickUpTextField.text = modalObj.strPickAddress;
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([modalObj.strPickLat doubleValue], [modalObj.strPickLong doubleValue]);
            GMSMarker *london = [GMSMarker markerWithPosition:position];
            london.title = modalObj.strPickAddress;
            london.icon = [UIImage imageNamed:@"map_pin"];
            london.map = self.riderGoogleMap;
        }else{
            self.pickUpTextField.text = @"";
 
        }

        
        camera = [GMSCameraPosition cameraWithLatitude:[obj.strLatitude  floatValue]
                                             longitude:[obj.strLongitude floatValue]
                                                  zoom:16];
        
        [self.riderGoogleMap setCamera:camera];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([obj.strLatitude doubleValue], [obj.strLongitude doubleValue]);
        GMSMarker *londonnew = [GMSMarker markerWithPosition:position];
        londonnew.title = modalObj.strTakeAddress;
        londonnew.icon = [UIImage imageNamed:@"Pin"];
        londonnew.map = self.riderGoogleMap;
       // self.riderGoogleMap.selectedMarker =london;
    }
    self.pickUpLabel.textColor = [UIColor colorWithRed:62/255.0 green:126/255.0 blue:189/255.0 alpha:1];
    self.whereToLabel.textColor = [UIColor colorWithRed:64/255.0 green:184/255.0 blue:151/255.0 alpha:1];
    
    [self addRouteOnGoogleMapWith:modalObj.strPickLat :modalObj.strPickLong andDestinationAddress:modalObj.strTakeLat :modalObj.strTakeLong];
    
    if (modalObj.strTakeAddress.length && modalObj.strPickAddress) {
        [self performSelector:@selector(moveToFareController) withObject:nil afterDelay:0.5];
    }
    
}

-(void)moveToFareController {
    
    FFComapreFareViewController *objVC = [[FFComapreFareViewController alloc]initWithNibName:@"FFComapreFareViewController" bundle:nil];
    objVC.modalObj = modalObj;
    objVC.compareDelegate = self;
    [self presentViewController:objVC animated:YES completion:nil];

}

-(void)moveToFareNewController {
    
    FFComapreFareViewController *objVC = [[FFComapreFareViewController alloc]initWithNibName:@"FFComapreFareViewController" bundle:nil];
    objVC.modalObj = self.modalObjNew;
    objVC.compareDelegate = self;
    [self presentViewController:objVC animated:YES completion:nil];
    
}



-(void)dismissCompareController:(NSString *)strPayment andIsPaid:(BOOL)paid {
    
    FFPaymentMethodViewController *historyVC= [[FFPaymentMethodViewController alloc]initWithNibName:@"FFPaymentMethodViewController" bundle:nil];
    UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:historyVC];
    historyVC.delegate = self;
    historyVC.strAmount = strPayment;
    historyVC.isFromPayment = YES;
    [self presentViewController:homeNav animated:YES completion:nil];
}

-(void)dismissToHomeController{
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    return center;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}




#pragma mark- Button Action Method

- (IBAction)menuBtnAction:(id)sender
{
    [self.view endEditing:YES];
    [APPDELEGATE stopLocation];
    [self.sidePanelController showLeftPanelAnimated:YES];
  }


- (IBAction)navigatoinBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&directionsmode=driving",[modalObj.strPickLat doubleValue],[modalObj.strPickLong
 doubleValue]];
    
    NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];

    
}


- (IBAction)commonBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    switch (sender.tag) {
        case 500: {
            FFSearchPlacesViewController *cardVC = [[FFSearchPlacesViewController alloc] initWithNibName:@"FFSearchPlacesViewController" bundle:nil];
            cardVC.delegate = self;
            cardVC.isForPlace = NO;
            cardVC.objDetail = modalObj;

            [self presentViewController:cardVC animated:YES completion:nil];
            
        }
            
            break;
        case 501: {
            FFSearchPlacesViewController *cardVC = [[FFSearchPlacesViewController alloc] initWithNibName:@"FFSearchPlacesViewController" bundle:nil];
            cardVC.delegate = self;
            cardVC.isForPlace = YES;
            cardVC.objDetail = modalObj;

            [self presentViewController:cardVC animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }

  
}
- (IBAction)whereToBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    FFSearchPlacesViewController *cardVC = [[FFSearchPlacesViewController alloc] initWithNibName:@"FFSearchPlacesViewController" bundle:nil];
    cardVC.delegate = self;
    cardVC.isForPlace = YES;
    cardVC.objDetail = modalObj;
    [self presentViewController:cardVC animated:YES completion:nil];
   
}

- (IBAction)commonSaveLocationButton:(UIButton *)sender{
    
    if ([favouriteArray count]) {
        FFHistoryInfo *info = [favouriteArray objectAtIndex:sender.tag];
        self.pickUpTextField.text = modalObj.strPickAddress;
        if ([info.title isEqualToString:@"Home"]){
            
            self.whereTextField.text = info.placeAddress;
            self.locationViewHeightConstraints.constant= 100;
            [self.whereToButton setHidden:YES];
            [self.locationDetailView setHidden:NO];
            modalObj.strTakeLat = info.placeLat;
            modalObj.strTakeLong = info.placeLong;
            modalObj.strTakeAddress = info.placeAddress;
        }
        else if ([info.title isEqualToString:@"Family"]){
            
            [self.familyBtn setTitle:[info.title uppercaseString] forState:UIControlStateNormal];
            self.whereTextField.text = info.placeAddress;
            self.locationViewHeightConstraints.constant= 100;
            [self.whereToButton setHidden:YES];
            [self.locationDetailView setHidden:NO];
            modalObj.strTakeLat = info.placeLat;
            modalObj.strTakeLong = info.placeLong;
            modalObj.strTakeAddress = info.placeAddress;
        }
        else if ([info.title isEqualToString:@"Work"]){
            [self.workBtn setTitle:[info.title uppercaseString] forState:UIControlStateNormal];
            self.whereTextField.text = info.placeAddress;
            self.locationViewHeightConstraints.constant= 100;
            [self.whereToButton setHidden:YES];
            [self.locationDetailView setHidden:NO];
            modalObj.strTakeLat = info.placeLat;
            modalObj.strTakeLong = info.placeLong;
            modalObj.strTakeAddress = info.placeAddress;
        }
        else{
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please add some location."
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
        
        self.pickUpLabel.textColor = [UIColor colorWithRed:62/255.0 green:126/255.0 blue:189/255.0 alpha:1];
        self.whereToLabel.textColor = [UIColor colorWithRed:64/255.0 green:184/255.0 blue:151/255.0 alpha:1];
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([modalObj.strPickLat doubleValue], [modalObj.strPickLong doubleValue]);
        GMSMarker *markNew = [GMSMarker markerWithPosition:position];
        markNew.title = modalObj.strPickAddress;
        markNew.icon = [UIImage imageNamed:@"map_pin"];
        markNew.map = self.riderGoogleMap;
        
        CLLocationCoordinate2D position1 = CLLocationCoordinate2DMake([modalObj.strTakeLat doubleValue], [modalObj.strTakeLong doubleValue]);
        GMSMarker *londonnew = [GMSMarker markerWithPosition:position1];
        londonnew.title = modalObj.strTakeAddress;
        londonnew.icon = [UIImage imageNamed:@"Pin"];
        londonnew.map = self.riderGoogleMap;
        
        [self addRouteOnGoogleMapWith:modalObj.strPickLat :modalObj.strPickLong andDestinationAddress:modalObj.strTakeLat :modalObj.strTakeLong];
        
        
        if (modalObj.strTakeAddress.length && modalObj.strPickAddress) {
            [self performSelector:@selector(moveToFareController) withObject:nil afterDelay:0.5];
        }
    }
    else{
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please add some location."
                                     andButtonsWithTitle:@[@"Ok"] onController:self
         
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                           }];
    
    }
}



-(void)addRouteOnGoogleMapWith: (NSString*)SourceAddressLat :(NSString*)SourceAddressLong andDestinationAddress :(NSString*)DestinationAddLat  : (NSString*)DestinationAddLong{
    //[APPDELEGATE showHudOnWindow];
    
    NSString* saddr = [NSString stringWithFormat:@"%@,%@", SourceAddressLat, SourceAddressLong];
    NSString* daddr = [NSString stringWithFormat:@"%@,%@", DestinationAddLat, DestinationAddLong];
    
 
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true",saddr,daddr]];
    
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
    singleLine.strokeColor = [UIColor colorWithRed:64/255.0 green:184/255.0 blue:151/255.0 alpha:1];
    singleLine.map = self.riderGoogleMap;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:Path];
    [self.riderGoogleMap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
}



-(void)checkLocationStatus {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to enable your GPS location?" andButtonsWithTitle:@[@"No",@"Yes"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle){
            if (index == 0 ) {
                [self checkLocationStatus];
                
            }else if (index == 1){
                
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
                else {
                    // Present some dialog telling the user to open the settings app.
                }
            }
        }];
        
    }else{
        
    }
}


#pragma mark- Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)callGetSavePlacedApi
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:@"list_savedLocation" forKey:kpAction];
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSMutableArray *arrayList = [result objectForKeyNotNull:@"LocationData" expectedObj:[NSMutableArray array]];
            if([arrayList count]) {
                
                int indexPathArray = 0;
                for (NSMutableDictionary *dic in arrayList)
                {
                    FFHistoryInfo  *objFav= [[FFHistoryInfo alloc]init];
                    objFav.title = [dic objectForKeyNotNull:@"title" expectedObj:@""];
                    if ([objFav.title isEqualToString:@"Home"]){
                        objFav.placeAddress = [dic objectForKeyNotNull:@"address" expectedObj:@""];
                        objFav.image = @"sel_home";
                        [self.homeBtn setTitle:[objFav.title uppercaseString] forState:UIControlStateNormal];
                        [self.homeBtn setImage:[UIImage imageNamed:objFav.image] forState:UIControlStateNormal];
                        [self.homeBtn setTitleColor:RGBCOLOR(61/255, 70/255,208/255 ,1.0) forState:UIControlStateNormal];
                        indexPathArray = 0;
                    }
                    else if ([objFav.title isEqualToString:@"Family"]){
                        objFav.placeAddress = [dic objectForKeyNotNull:@"address" expectedObj:@""];
                        objFav.image = @"sel_family";
                        [self.familyBtn setTitle:[objFav.title uppercaseString] forState:UIControlStateNormal];
                        [self.familyBtn setImage:[UIImage imageNamed:objFav.image] forState:UIControlStateNormal];
                        [self.familyBtn setTitleColor:RGBCOLOR(61/255, 70/255,208/255 ,1.0) forState:UIControlStateNormal];
                        indexPathArray = 1;
                    }
                    else{
                        objFav.placeAddress = [dic objectForKeyNotNull:@"address" expectedObj:@""];
                        objFav.image = @"sel_work";
                        [self.workBtn setTitle:[objFav.title uppercaseString] forState:UIControlStateNormal];
                        [self.workBtn setImage:[UIImage imageNamed:objFav.image] forState:UIControlStateNormal];
                        [self.workBtn setTitleColor:RGBCOLOR(61/255, 70/255,208/255 ,1.0) forState:UIControlStateNormal];
                        indexPathArray = 2;
                    }
                    objFav.placeLat = [dic objectForKeyNotNull:@"latitude" expectedObj:@""];
                    objFav.placeLong = [dic objectForKeyNotNull:@"longitude" expectedObj:@""];
                    
                    objFav.locationId = [dic objectForKeyNotNull:@"location_id" expectedObj:@""];
                    [favouriteArray replaceObjectAtIndex:indexPathArray withObject:objFav];
                    modalObj.favArray =[[NSMutableArray alloc] init];
                    modalObj.favArray = favouriteArray;
                }
            }
        }
        else
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
    }];
}




@end
