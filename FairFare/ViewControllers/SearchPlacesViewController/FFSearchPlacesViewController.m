//
//  FFSearchPlacesViewController.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 04/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFSearchPlacesViewController.h"
#import "ACFloatingTextField.h"
@interface FFSearchPlacesViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate,GMSAutocompleteFetcherDelegate,UITextFieldDelegate> {
    CLLocationCoordinate2D coordinate;
    NSMutableArray *dataArray;
    NSMutableArray *dataSourceArray,*favArray;
    GMSAutocompleteFetcher* _fetcher;
    ModalHome *modalObjHome;
}


@property (strong, nonatomic) IBOutlet GMSMapView *riderGoogleMap;

@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UIView *locationDetailView;
@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) IBOutlet UIView *favView;
@property (strong, nonatomic) IBOutlet UIView *officeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint_bottomView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *pickUpTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *whereTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *favViewWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *homeViewWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *officeViewWidthConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationButtonXConstraints;
@property (strong, nonatomic) IBOutlet UILabel *pickUpLabel;
@property (strong, nonatomic) IBOutlet UILabel *whereToLabel;

@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *familyBtn;
@property (weak, nonatomic) IBOutlet UIButton *workBtn;

@end

@implementation FFSearchPlacesViewController

#pragma mark- Life cycle of view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    modalObjHome = [[ModalHome alloc]init];
    dataSourceArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    favArray = self.objDetail.favArray;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [APPDELEGATE startLocation];
    [self customizeView];
    [self getPlace];

    [SSAUtility createShadowOnUIControl:self.homeView];
    [SSAUtility createShadowOnUIControl:self.officeView];
    [SSAUtility createShadowOnUIControl:self.favView];
    [SSAUtility createShadowOnUIControl:self.locationView];
    [self.searchView setHidden:YES];
    [self.searchTableView registerNib:[UINib nibWithNibName:@"FFSearchPlacesTableCell" bundle:nil] forCellReuseIdentifier:@"FFSearchPlacesTableCell"];
    
    self.pickUpTextField.placeholder = @"Pick Up";
    self.whereTextField.placeholder = @"Where to ";

    
    if (self.objDetail.strTakeAddress.length) {
        self.whereTextField.text = self.objDetail.strTakeAddress;
    }
    if (self.objDetail.strPickAddress.length) {
        self.pickUpTextField.text = self.objDetail.strPickAddress;

    }
    
    if (WIN_WIDTH == 320) {
        self.favViewWidthConstraints.constant = 75;
        self.officeViewWidthConstraints.constant = 95;
        self.homeViewWidthConstraints.constant = 70;
        self.navigationButtonXConstraints.constant = 0;
        
    }

    
    if (self.isForPlace) {
        [self.whereTextField becomeFirstResponder];


    }else{
        [self.pickUpTextField becomeFirstResponder];
    }
    
    
    
    for (FFHistoryInfo  *objFav in favArray)
    {
        if ([objFav.title isEqualToString:@"Home"]){
            objFav.placeAddress = objFav.placeAddress;
            objFav.image = @"sel_home";
            [self.homeBtn setTitle:[objFav.title uppercaseString] forState:UIControlStateNormal];
            [self.homeBtn setImage:[UIImage imageNamed:objFav.image] forState:UIControlStateNormal];
            [self.homeBtn setTitleColor:RGBCOLOR(61/255, 70/255,208/255 ,1.0) forState:UIControlStateNormal];
        }
        else if ([objFav.title isEqualToString:@"Family"]){
             objFav.placeAddress = objFav.placeAddress;
            objFav.image = @"sel_family";
            [self.familyBtn setTitle:[objFav.title uppercaseString] forState:UIControlStateNormal];
            [self.familyBtn setImage:[UIImage imageNamed:objFav.image] forState:UIControlStateNormal];
            [self.familyBtn setTitleColor:RGBCOLOR(61/255, 70/255,208/255 ,1.0) forState:UIControlStateNormal];
            
        }
        else if ([objFav.title isEqualToString:@"Work"]){
            objFav.placeAddress = objFav.placeAddress;
            objFav.image = @"sel_work";
            [self.workBtn setTitle:[objFav.title uppercaseString] forState:UIControlStateNormal];
            [self.workBtn setImage:[UIImage imageNamed:objFav.image] forState:UIControlStateNormal];
            [self.workBtn setTitleColor:RGBCOLOR(61/255, 70/255,208/255 ,1.0) forState:UIControlStateNormal];
        }        
        objFav.placeLat = objFav.placeLat;
        objFav.placeLong = objFav.placeLong;
    }


}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}


- (IBAction)commonSaveLocationButton:(UIButton *)sender{
    
    [self.view endEditing:YES];
    if ([favArray count]) {
        
        FFHistoryInfo *info = [favArray objectAtIndex:sender.tag];
        if ([info.title isEqualToString:@"Home"]){
            
            self.whereTextField.text = info.placeAddress;
            [self.locationDetailView setHidden:NO];
            modalObjHome.strLatitude = info.placeLat;
            modalObjHome.strLongitude = info.placeLong;
            modalObjHome.strFullAddress = info.placeAddress;
        }
        else if ([info.title isEqualToString:@"Family"]){
            
            [self.familyBtn setTitle:[info.title uppercaseString] forState:UIControlStateNormal];
            self.whereTextField.text = info.placeAddress;
            [self.locationDetailView setHidden:NO];
            modalObjHome.strLatitude = info.placeLat;
            modalObjHome.strLongitude = info.placeLong;
            modalObjHome.strFullAddress = info.placeAddress;
        }
        else if ([info.title isEqualToString:@"Work"]){
            [self.workBtn setTitle:[info.title uppercaseString] forState:UIControlStateNormal];
            self.whereTextField.text = info.placeAddress;
            [self.locationDetailView setHidden:NO];
            modalObjHome.strLatitude = info.placeLat;
            modalObjHome.strLongitude = info.placeLong;
            modalObjHome.strFullAddress = info.placeAddress;
        }
        else{
            
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (self && self.delegate && [self.delegate respondsToSelector:@selector(getPlaceString:andIsFor:)]) {
                [self.delegate getPlaceString:modalObjHome andIsFor:self.isForPlace];
            }
            
        }];
    }
    else{
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please add some location."
                                     andButtonsWithTitle:@[@"Ok"] onController:self
         
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                           }];
        
    }

}

#pragma mark - TextField Delegate Method
-(void)refreshSearchedDataForText:(NSString*)text {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self performSelector:@selector(callAPIFor_SearchPlace:) withObject:text afterDelay:0];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 1000: {
            self.isForPlace = NO;
            self.pickUpLabel.textColor = [UIColor colorWithRed:62/255.0 green:126/255.0 blue:189/255.0 alpha:1];
        }
            
            break;
        case 1001: {
            self.isForPlace = YES;
            self.whereToLabel.textColor = [UIColor colorWithRed:64/255.0 green:184/255.0 blue:151/255.0 alpha:1];

        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 1000: {
            self.isForPlace = NO;
            self.pickUpLabel.textColor = [UIColor lightGrayColor];

        }
            
            break;
        case 1001: {
            self.isForPlace = YES;
            self.whereToLabel.textColor = [UIColor lightGrayColor];
        }
            
            break;
            
        default:
            break;
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    NSString *newTextToBe = [[textField text] stringByReplacingCharactersInRange:range withString:string];
   
    [self refreshSearchedDataForText:newTextToBe];
    
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeyNext) {
        UITextField *next = [self.view viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    }
    
    else  {
        [textField resignFirstResponder];
    }
    return YES;
}


-(void)callAPIFor_SearchPlace :(NSString *)text {
    [_fetcher sourceTextHasChanged:text];

}



-(void) getPlace
{
    // Set up the autocomplete filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterGeocode;
    //filter.country = @"USA";
    // Create the fetcher.
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:nil
                                                       filter:filter];
    _fetcher.delegate = self;
}

#pragma mark - GMSAutocompleteFetcherDelegate

- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    NSMutableString *resultsStr = [NSMutableString string];
    [dataArray removeAllObjects];
    for (GMSAutocompletePrediction *prediction in predictions) {
        [resultsStr appendFormat:@"%@\n", [prediction.attributedFullText string]];
        ModalHome *obj = [[ModalHome alloc] init];
        obj.strAddress = [prediction.attributedPrimaryText string];
        obj.strLocation= [prediction.attributedSecondaryText string];
        obj.strFullAddress= [prediction.attributedFullText string];

        [dataArray addObject:obj];
    }
    
    dataArray=[[[dataArray reverseObjectEnumerator] allObjects] mutableCopy];

    
    if (dataArray.count) {
        [self.searchView setHidden:NO];
        [self scrollToBottom];
    }else {
        [self.searchView setHidden:YES];
    }
    
    [self.searchTableView reloadData];
}

// use to scroll the table view at bottom index
-(void)scrollToBottom {
    
    if (dataArray.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[dataArray count]-1 inSection:0];
                [self.searchTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        });
    }
    
    
}


- (void)didFailAutocompleteWithError:(NSError *)error {
    NSLog(@"==== Error ======= %@",[NSString stringWithFormat:@"%@", error.localizedDescription]);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error{
    
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController{
    
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count) {
        return dataArray.count;
    }
    else
        return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFSearchPlacesTableCell *cell = (FFSearchPlacesTableCell *)[self.searchTableView dequeueReusableCellWithIdentifier:NSStringFromClass([FFSearchPlacesTableCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.view_OuterView.layer.borderColor = [UIColor colorWithRed:200.0/255.0f green:200.0/255.0f blue:200.0/255.0f alpha:1.0f].CGColor;
    cell.view_OuterView.layer.borderWidth = 0.5f;
    cell.view_OuterView.layer.masksToBounds = YES;
    cell.label_DynamicAddress.hidden = NO;
    UserInfo *obj  = [dataArray objectAtIndex:indexPath.row];
    [cell.label_DynamicAddress setText:obj.strAddress];
    [cell.label_Address setText:obj.strLocation];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    ModalHome *obj  = [dataArray objectAtIndex:indexPath.row];

    if (self.isForPlace) {
        self.whereTextField.text = obj.strFullAddress;
    }else{
        self.pickUpTextField.text = obj.strFullAddress;

    }
    
    modalObjHome =[dataArray objectAtIndex:indexPath.row];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self && self.delegate && [self.delegate respondsToSelector:@selector(getPlaceString:andIsFor:)]) {
            [self.delegate getPlaceString:modalObjHome andIsFor:self.isForPlace];
        }
        
    }];
}



#pragma mark - Notification Methods

- (void)keyboardWillShow:(NSNotification *)note {
   
    CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.bottomConstraint_bottomView.constant = kbSize.height;
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.bottomConstraint_bottomView.constant = 0;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        
       
        
    }];
}


#pragma mark- Helper method for view controller
-(void)customizeView{
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate at zoom level 6.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[APPDELEGATE latitude] floatValue]
                                                            longitude:[[APPDELEGATE longitude] floatValue]
                                                                 zoom:16];
    
    [self.riderGoogleMap setDelegate:self];
    self.riderGoogleMap.myLocationEnabled = YES;
    [self.riderGoogleMap setMapType:kGMSTypeNormal];
    [self.riderGoogleMap setCamera:camera];
    
    if ([NSUSERDEFAULT boolForKey:kIsRideInProgress]) {
        
        //  FFRequestForRideVC *objVC = [[FFRequestForRideVC alloc]initWithNibName:@"FFRequestForRideVC" bundle:nil];
        // [self.navigationController pushViewController:objVC animated:NO];
    }
}





#pragma mark- Button Action Method

- (IBAction)backBtnAction:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)navigatoinBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&directionsmode=driving",[self.objDetail.strPickLat doubleValue],[self.objDetail.strPickLong doubleValue]];
    
    NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
    
}





#pragma mark- Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
