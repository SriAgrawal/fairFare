//
//  FFComapreFareViewController.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 08/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFComapreFareViewController.h"
#import "FFCompareTableViewCell.h"
#import <GoogleMaps/GoogleMaps.h>


@interface FFComapreFareViewController ()<GMSMapViewDelegate,dismissToPaymentDelegate> {
    
    CLLocationCoordinate2D _source;
    CLLocationCoordinate2D _destination;
    NSArray *tableData;
    NSMutableArray *dataSourceArray, *arrivalTimeArray, *compareArrayList;
    float fairFareFee;
    
}

@property (strong, nonatomic) IBOutlet UIView *paymentView;
@property (strong, nonatomic) IBOutlet GMSMapView *riderGoogleMap;
@property (strong, nonatomic) IBOutlet UIView *fareButtonView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *compareViewHeightConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *paymentViewHeightConstraints;
@property (strong, nonatomic) IBOutlet UIButton *fairFareButton;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *fairFareFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickUp;
@property (weak, nonatomic) IBOutlet UILabel *takeAddress;

@property (strong, nonatomic) IBOutlet UIView *markerViewData;
@property (strong, nonatomic) IBOutlet UIView *markerViewTakeData;


@end

@implementation FFComapreFareViewController


#pragma mark- UIViewController Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataSourceArray = [[NSMutableArray alloc] init];
    arrivalTimeArray = [[NSMutableArray alloc] init];
    compareArrayList = [[NSMutableArray alloc] init];
    [self.riderGoogleMap setDelegate:self];
    self.riderGoogleMap.myLocationEnabled = NO;
    [self.riderGoogleMap setMapType:kGMSTypeNormal];
    [SSAUtility createShadowOnUIControl:self.fareButtonView];
    
    [self performSelector:@selector(mapScreenShotAndHandleRoute) withObject:nil afterDelay:0.1];
    
    [self initialSetup];
    //[self mapSetup];

    
}

-(void)mapScreenShotAndHandleRoute{

    [[NSBundle mainBundle] loadNibNamed:@"FFMarkerView" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"FFTakeMarkerView" owner:self options:nil];
    
    self.pickUp.text =self.modalObj.strPickAddress;
    self.takeAddress.text =self.modalObj.strTakeAddress;
    
    UIImage *imageScreen;
    imageScreen = [self getScreenOfGiveView];
    
    UIImage *imageScreenTake;
    imageScreenTake = [self getScreenOfTakeView];
    
    
    CLLocationCoordinate2D positionTake = CLLocationCoordinate2DMake([self.modalObj.strTakeLat doubleValue], [self.modalObj.strTakeLong doubleValue]);
    GMSMarker *takeAddre = [GMSMarker markerWithPosition:positionTake];
    takeAddre.icon = imageScreenTake;
    takeAddre.map = self.riderGoogleMap;
    
    CLLocationCoordinate2D positionPick = CLLocationCoordinate2DMake([self.modalObj.strPickLat doubleValue], [self.modalObj.strPickLong doubleValue]);
    GMSMarker *pickAddress = [GMSMarker markerWithPosition:positionPick];
    pickAddress.icon = imageScreen;
    pickAddress.map = self.riderGoogleMap;
    self.paymentViewHeightConstraints.constant = 0;
    self.compareViewHeightConstraints.constant = 0;
    [self.paymentView setHidden:YES];
    [self.tableView setHidden:YES];
    
    [self addRouteOnGoogleMapWithFare:self.modalObj.strPickLat :self.modalObj.strPickLong andDestinationAddress:self.modalObj.strTakeLat :self.modalObj.strTakeLong];

}


-(void)mapSetup {

    
    CGPoint pointtake = [_riderGoogleMap.projection pointForCoordinate: CLLocationCoordinate2DMake([self.modalObj.strTakeLat doubleValue], [self.modalObj.strTakeLong doubleValue])];
    CGPoint pointpic = [_riderGoogleMap.projection pointForCoordinate: CLLocationCoordinate2DMake([self.modalObj.strPickLat doubleValue], [self.modalObj.strPickLong doubleValue])];
    
    CGPoint point1;
    CGPoint point2;

    if ((pointpic.x - pointtake.x) > (pointpic.y - pointtake.y)) {
        
        point1 = CGPointMake((pointpic.x - pointtake.x)/2, pointpic.y);
        point2 = CGPointMake(point1.x , point2.y);
    }else{
        point1 = CGPointMake(pointpic.x , ((pointpic.y - pointtake.y) /2));
        point2 = CGPointMake(pointtake.x , point1.y);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(pointpic.x, (pointpic.y + pointtake.y)/2)];
    
    [path addCurveToPoint:point1 controlPoint1:point1 controlPoint2:point2];
    
//    CAShapeLayer *lay = [[CAShapeLayer alloc]init];
//    lay.path = path.CGPath;
//    lay.strokeColor = [UIColor greenColor].CGColor;
    
    //[self.riderGoogleMap.layer addSublayer:lay];
    
    

    
}

#pragma mark - Helper Method

-(UIImage *)getScreenOfGiveView{
    
    UIGraphicsBeginImageContextWithOptions([self.markerViewData bounds].size, NO, 0.0f);
    [self.markerViewData drawViewHierarchyInRect:self.markerViewData.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage *)getScreenOfTakeView{
    
    UIGraphicsBeginImageContextWithOptions([self.markerViewTakeData bounds].size, NO, 0.0f);
    [self.markerViewTakeData drawViewHierarchyInRect:self.markerViewTakeData.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)initialSetup{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FFCompareTableViewCell" bundle:nil] forCellReuseIdentifier:@"FFCompareTableViewCell"];

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
#pragma mark - UITableView Datasource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  compareArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFCompareTableViewCell *cell = (FFCompareTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"FFCompareTableViewCell"];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    ModalComapreCost *modalObjectCell = [compareArrayList objectAtIndex:indexPath.row];
    
    if ([modalObjectCell.strUberName isEqualToString:@"Uber"])
    {
        cell.ETATimeLabel.text = modalObjectCell.strEstimateTime;
      //  cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"IN %@ MIN", modalObjectCell.strEstimateTimeinMin];
        cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"IN %@ MIN", modalObjectCell.strArrivalTime];

        cell.valueLabel.text = modalObjectCell.strCompanyFare;
        cell.serviceNameLbl.text = NSLocalizedString(modalObjectCell.strCompanyName,nil);
        cell.tagImageView.image = [UIImage imageNamed:modalObjectCell.strCompanyLogo];
        
    }
    else
    {
        if ([modalObjectCell.strLyftTime length] == 0 && [modalObjectCell.strCompanyFare length]==0)
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:@" Lyft is not yet available in this region"
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
            
        }
        else if ([modalObjectCell.strLyftTime isEqualToString:@"0:0"] && [modalObjectCell.strCompanyFare isEqualToString:@"0.00"])
        {
            cell.ETATimeLabel.text = NSLocalizedString(@"---",nil);
            cell.valueLabel.text = NSLocalizedString(@"---",nil);
            cell.serviceNameLbl.text = modalObjectCell.strCompanyName;
            cell.tagImageView.image = [UIImage imageNamed:modalObjectCell.strCompanyLogo];
        }
        else
        {
            //cell.ETATimeLabel.text = modalObjectCell.strLyftTime;
          //  cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"IN %@ MIN", modalObjectCell.strEstimateTimeinMin];
            cell.ETATimeLabel.text = modalObjectCell.strLyftTime;
            cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"IN %@ MIN", modalObjectCell.strArrivalTime];
            cell.valueLabel.text = [NSString stringWithFormat:@"%@",modalObjectCell.strCompanyFare];
            cell.serviceNameLbl.text = modalObjectCell.strCompanyName;
            cell.tagImageView.image = [UIImage imageNamed:modalObjectCell.strCompanyLogo];
        }
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  //  [[AlertView sharedManager] presentAlertWithTitle:@"Book A Ride" message:@"For booking this ride you have to pay 5.5% of fare to FairFare. \nAre you sure want to book?" andButtonsWithTitle:@[@"YES",@"NO"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
       // if ([buttonTitle isEqualToString:@"YES"]) {
            
            self.compareViewHeightConstraints.constant = 0;
            ModalComapreCost *compareObj = [compareArrayList objectAtIndex:indexPath.row];
            self.subTotalLabel.text = compareObj.strCompanyFare;
            fairFareFee = ((5.5 * ([compareObj.strEstimateCost floatValue]))/100);
            self.fairFareFeeLabel.text = [NSString stringWithFormat:@"$%0.2f",fairFareFee];
            self.totalAmountLbl.text = [NSString stringWithFormat:@"$%0.2f",([compareObj.strEstimateCost floatValue] + fairFareFee)];
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                [self.view layoutSubviews];
            } completion:^(BOOL finished){
                [self.tableView setHidden:YES];
                [self showPaymentView];
                
            }];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@,%@",self.modalObj.strPickLat , self.modalObj.strPickLong ] forKey:@"strPickMe"];
            [dict setValue:[NSString stringWithFormat:@"%@,%@", self.modalObj.strTakeLat, self.modalObj.strTakeLong] forKey:@"strTakeMeTo"];
            [dict setValue:compareObj.strRideType forKey:@"rideType"];
            [dict setValue:compareObj.strProductId forKey:@"product_id"];
            [dict setValue:compareObj.strUberName forKey:@"serviceName"];
    
            [dict setValue:self.modalObj.strPickAddress forKey:@"pickAddress"];
            [dict setValue:self.modalObj.strTakeAddress forKey:@"takeAddress"];
            [dict setValue:[NSString stringWithFormat:@"%0.2f",([compareObj.strEstimateCost floatValue] + fairFareFee)] forKey:@"totalAmount"];

            NSData *serializedData= [NSKeyedArchiver archivedDataWithRootObject:dict];
            
            [NSUSERDEFAULT setValue:serializedData forKey:@"data"];
            
     //   }
        
    
}

-(void)showPaymentView{
    self.paymentViewHeightConstraints.constant = 181;
    [self.paymentView setHidden:NO];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.view layoutSubviews];
    } completion:^(BOOL finished){
       
    }];
}

#pragma mark- Button Action Method

- (IBAction)backBtnAction:(id)sender
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataRefresh" object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)payButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self.compareDelegate dismissCompareController:[NSString stringWithFormat:@"%0.2f",fairFareFee] andIsPaid:YES];
    }];
   
}
- (IBAction)cancelButtonAction:(id)sender {
    self.paymentViewHeightConstraints.constant = 0;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.view layoutSubviews];
    } completion:^(BOOL finished){
        [self.paymentView setHidden:YES];
    }];
}


- (IBAction)fareBtnAction:(id)sender {
    [self.view endEditing:YES];
    [self callApiLyftAuthroized];
    self.compareViewHeightConstraints.constant = 370;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.view layoutSubviews];
    } completion:^(BOOL finished){
        [self.tableView setHidden:NO];
        
        
    }];
    
}


-(void)dismissToHomeController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*********************** Service Implementation Methods ****************/

-(void)callApiLyftAuthroized
{

    NSMutableDictionary *valueToken = [[NSMutableDictionary alloc] init];
    [valueToken setValue: @"client_credentials"
                  forKey:@"grant_type"];
    [valueToken setObject:@"public" forKey:@"scope"];
    
    [[ISServiceHelper sharedInstance]PostAPICallWithParameter:valueToken AndApiType:@"Lyft" WithComptionBlock:^(id result, NSError *error){
        [NSUSERDEFAULT setObject:[result objectForKeyNotNull:@"access_token" expectedObj:@""] forKey:@"access_token"];
        [NSUSERDEFAULT setObject:[result objectForKeyNotNull:@"token_type" expectedObj:@""] forKey:@"token_type"];
        [NSUSERDEFAULT synchronize];
        [self callLyftApi];
    }];
    
}
-(void)callLyftApi
{
    
    NSMutableDictionary *valueSignIn = [[NSMutableDictionary alloc] init];
   
        [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLat doubleValue]] forKey:@"start_lat"];
        [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLong doubleValue]] forKey:@"start_lng"];
    
        [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strTakeLat doubleValue]] forKey:@"end_lat"];
        [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strTakeLong doubleValue]] forKey:@"end_lng"];
    
    [[ISServiceHelper sharedInstance]GetAPICallWithParameter:valueSignIn AndApitype:1 AndAPIName:@"cost" WithComptionBlock:^(id result, NSError *error){
        [dataSourceArray removeAllObjects];
        
        NSArray *arrayList = [result objectForKeyNotNull:@"cost_estimates" expectedObj:[NSArray array]];
        for (NSMutableDictionary *dic in arrayList)
        {
            ModalComapreCost *modalObjectCost = [[ModalComapreCost alloc]init];
            
            NSTimeInterval timeInterval = [[dic objectForKeyNotNull:@"estimated_duration_seconds" expectedObj:@""] intValue];
            long seconds = lroundf(timeInterval);
            //int eta_hours = (int)seconds / 3600;
            int eta = (int)(seconds % 3600) / 60;

            float centCost = (([[dic objectForKeyNotNull:@"estimated_cost_cents_max" expectedObj:@""] intValue])+([[dic objectForKeyNotNull:@"estimated_cost_cents_min" expectedObj:@""] intValue]))/2;
            
            float dollarCost = centCost/100;
            modalObjectCost.strLyftTime = [self timeForEstimateFormated:seconds];
            modalObjectCost.strRideType = [dic objectForKeyNotNull:@"ride_type" expectedObj:@""];
            modalObjectCost.strEstimateTimeinMin = [NSString stringWithFormat:@"%d",eta];
            modalObjectCost.strCompanyLogo = @"l";
            modalObjectCost.strCompanyName = [dic objectForKeyNotNull:@"display_name" expectedObj:@""];
            modalObjectCost.strLyftName = @"Lyft";
            modalObjectCost.strEstimateCost = [NSString stringWithFormat:@"%.02f", dollarCost];
            modalObjectCost.strCompanyFare = [NSString stringWithFormat:@"$%.02f", dollarCost];
            [dataSourceArray addObject:modalObjectCost];
        }
        
        [self callApiLyftForArrivalTime];
    }];
}


-(void)callApiLyftForArrivalTime
{
    NSMutableDictionary *valueSignIn = [[NSMutableDictionary alloc] init];
    
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLat doubleValue]] forKey:@"lat"];
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLong doubleValue]] forKey:@"lng"];
    
    
    [[ISServiceHelper sharedInstance]GetAPICallWithParameter:valueSignIn AndApitype:1 AndAPIName:@"eta" WithComptionBlock:^(id result, NSError *error){
        
        NSArray *arrayList = [result objectForKeyNotNull:@"eta_estimates" expectedObj:[NSArray array]];
        for (NSMutableDictionary *dic in arrayList)
        {
            ModalRiderList *modalObjectLfyt = [[ModalRiderList alloc]init];
            int eta = ([[dic objectForKeyNotNull:@"eta_seconds" expectedObj:@""] intValue])/60;
            modalObjectLfyt.strEstimateTime = [NSString stringWithFormat:@"%d",eta];
            modalObjectLfyt.strRideType = [dic objectForKeyNotNull:@"ride_type" expectedObj:@""];
            [arrivalTimeArray addObject:modalObjectLfyt];
            
        }
        
        [self callApiUberForArrivalTime];
    }];
    
}

-(void)callApiUberForArrivalTime
{
    
    
    NSMutableDictionary *valueSignIn = [[NSMutableDictionary alloc] init];
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLat doubleValue]] forKey:@"start_latitude"];
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLong doubleValue]] forKey:@"start_longitude"];
    
    [valueSignIn setObject:SERVER_TOKEN forKey:@"server_token"];
    
    [[ISServiceHelper sharedInstance]GetAPICallWithParameter:valueSignIn AndApitype:2 AndAPIName:@"estimates/time" WithComptionBlock:^(id result, NSError *error){
        
        NSArray *arrayList = [result objectForKeyNotNull:@"times" expectedObj:[NSArray array]];
        for (NSMutableDictionary *dic in arrayList)
        {
            ModalRiderList *modalObjectUber = [[ModalRiderList alloc]init];
            int eta = ([[dic objectForKeyNotNull:@"estimate" expectedObj:@""] intValue])/60;
            modalObjectUber.strEstimateTime = [NSString stringWithFormat:@"%d",eta];
            modalObjectUber.strProductId = [dic objectForKeyNotNull:kProduct_id expectedObj:@""];
            [arrivalTimeArray addObject:modalObjectUber];
            
        }
        
        [self callApiUber];
    }];
}

-(void)callApiUber
{
    
    NSMutableDictionary *valueSignIn = [[NSMutableDictionary alloc] init];
    
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLat doubleValue]] forKey:@"start_latitude"];
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strPickLong doubleValue]] forKey:@"start_longitude"];
    
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strTakeLat doubleValue]] forKey:@"end_latitude"];
    [valueSignIn setValue:[NSString stringWithFormat:@"%f",[self.modalObj.strTakeLong doubleValue]] forKey:@"end_longitude"];
    
    [valueSignIn setObject:SERVER_TOKEN forKey:@"server_token"];
    
    [[ISServiceHelper sharedInstance]GetAPICallWithParameter:valueSignIn AndApitype:2 AndAPIName:@"estimates/price" WithComptionBlock:^(id result, NSError *error){
        
        NSArray *arrayList = [result objectForKeyNotNull:@"prices" expectedObj:[NSArray array]];
        for (NSMutableDictionary *dic in arrayList)
        {
            ModalComapreCost *modalObjectUber = [[ModalComapreCost alloc]init];
            //int eta = ([[dic objectForKeyNotNull:@"duration" expectedObj:@""] intValue])/60;
            NSTimeInterval timeInterval = [[dic objectForKeyNotNull:@"duration" expectedObj:@""] intValue];
            long seconds = lroundf(timeInterval);
            //int eta_hours = (int)seconds / 3600;
            int eta = (int)(seconds % 3600) / 60;
            modalObjectUber.strEstimateTimeinMin = [NSString stringWithFormat:@"%d",eta];
            // int eta_hours = eta/60*60;
            
            
            modalObjectUber.strEstimateTime = [self timeForEstimateFormated:seconds];
            
            float centCost = (([[dic objectForKeyNotNull:@"high_estimate" expectedObj:@""] intValue])+([[dic objectForKeyNotNull:@"low_estimate" expectedObj:@""] intValue]))/2;
            
            //float dollarCost = centCost/100;
            
            modalObjectUber.strCompanyName = [dic objectForKeyNotNull:@"localized_display_name" expectedObj:@""];
            modalObjectUber.strProductId = [dic objectForKeyNotNull:kProduct_id expectedObj:@""];
            modalObjectUber.strCompanyLogo = @"uber_img";
            modalObjectUber.strUberName  = @"Uber";
            modalObjectUber.strEstimateCost = [NSString stringWithFormat:@"%.02f", centCost];
            modalObjectUber.strCompanyFare = [NSString stringWithFormat:@"$%0.2f",centCost];
            [dataSourceArray addObject:modalObjectUber];
        }

        NSMutableArray *arrTemp = [NSMutableArray arrayWithArray:dataSourceArray];
        [arrTemp sortUsingComparator:^NSComparisonResult(ModalComapreCost *item1, ModalComapreCost *item2) {
            return [item2.strEstimateCost compare:item1.strEstimateCost options:NSNumericSearch];
        }];
        [dataSourceArray removeAllObjects];
        dataSourceArray = [NSMutableArray arrayWithArray:[[arrTemp reverseObjectEnumerator] allObjects]];
        
        [self compareTwoList];
        //[self.tableView reloadData];
    }];
}

-(NSString *)timeForEstimateFormated:(long)estimateTime{

    NSDate *currentDateTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    currentDateTime=[currentDateTime dateByAddingTimeInterval:estimateTime];

    return  [dateFormatter stringFromDate:currentDateTime];
}

-(void)compareTwoList{
    
    [compareArrayList removeAllObjects];
    for (ModalComapreCost *costObj in dataSourceArray) {
        ModalComapreCost *compareObj = [[ModalComapreCost alloc] init];
        for (ModalRiderList *arrivalObj in arrivalTimeArray) {
            
            if ([costObj.strProductId isEqualToString: arrivalObj.strProductId] || [costObj.strRideType isEqualToString:arrivalObj.strRideType]) {
                
                compareObj.strCompanyName = costObj.strCompanyName;
                compareObj.strProductId = costObj.strProductId;
                compareObj.strCompanyLogo = costObj.strCompanyLogo;
                compareObj.strUberName  = costObj.strUberName;
                compareObj.strLyftName =  costObj.strLyftName;
                compareObj.strEstimateCost = costObj.strEstimateCost;
                compareObj.strCompanyFare = costObj.strCompanyFare;
                compareObj.strLyftTime = costObj.strLyftTime;
                compareObj.strRideType =  costObj.strRideType;
                compareObj.strEstimateTimeinMin = costObj.strEstimateTimeinMin;
                compareObj.strEstimateTime = costObj.strEstimateTime;
                compareObj.strArrivalTime = arrivalObj.strEstimateTime;
                [compareArrayList addObject:compareObj];
                break;
            }
        }
    }
    [self.tableView reloadData];
}


#pragma mark- Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
