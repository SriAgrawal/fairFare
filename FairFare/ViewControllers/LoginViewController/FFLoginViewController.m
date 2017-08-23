//
//  FFLoginViewController.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 03/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFLoginViewController.h"
#import "NSDictionary+NullChecker.h"
#import "RequestTimeOutView.h"
#import "Header.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTSubscriberInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface FFLoginViewController (){
    UserInfo *loginInfo;
    NSMutableArray* counrtyArray;
    NSString *countryDialingCode;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PATextField *mobileTextFields;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLineLabel;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end

@implementation FFLoginViewController

#pragma mark- Life cycle of view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([NSUSERDEFAULT boolForKey:kIsLoggedIn]) {
        [self.navigationController pushViewController:[APPDELEGATE addRevealView] animated:YES];
    }
    
    //getting the country list
    counrtyArray = [[NSMutableArray alloc] init];
  
    //Setting up the Intial Setup Method
    [self initialSetUp];
    countryDialingCode =  [self getCountry];
    [self getCounrtyListArray];
}

-(void)initialSetUp{
    
    self.tableView.tableHeaderView = self.headerView;
    loginInfo = [[UserInfo alloc] init];
    loginInfo.strCountryCode = @"+91";
    //Manage the error label
    self.errorMessageLabel.hidden = YES;
    self.errorLineLabel.backgroundColor = [UIColor whiteColor];
    
    //Setting the View on the keyboard as toolbar view
    self.mobileTextFields.inputAccessoryView = setToolbarViewCustom(self);
    [self.mobileTextFields becomeFirstResponder];
}

-(BOOL)validateDetails{

    if(!loginInfo.strContact.length && !(self.mobileTextFields.text.length)){
        self.errorMessageLabel.hidden = NO;
            [UIView transitionWithView:self.errorMessageLabel
                              duration:0.70f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.errorMessageLabel.text = KAlert_BLANKCONTACT;
                            } completion:nil];
        self.errorLineLabel.backgroundColor = [UIColor redColor];
        
        return false;
    }
    else if (loginInfo.strContact.length < 10 && (self.mobileTextFields.text.length) < 10) {
        self.errorMessageLabel.hidden = NO;
        self.errorLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_MIN_CONTACT;
        return false;
    }
    else{
    return true;
    }
}

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.errorMessageLabel.hidden = YES;
    self.errorLineLabel.backgroundColor = [UIColor whiteColor];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.errorMessageLabel.hidden = YES;
    self.errorLineLabel.backgroundColor = [UIColor whiteColor];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    return (textField.text.length >= 10 && range.length == 0)? NO : YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    loginInfo.strContact =textField.text;
}

#pragma mark - UIButton Action Method
- (IBAction)countryPicker:(id)sender {
    [self.view endEditing:YES];
    [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:counrtyArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        NSArray *codeArray = [selectedText componentsSeparatedByString:@" "];
        loginInfo.strCountryCode = [codeArray firstObject];
        [self.countryCodeButton setTitle:selectedText forState:UIControlStateNormal];
    }];
}
#pragma mark - Helping Method

-(void)dismissKeyboard:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

- (void)doneWithNumberPad{
    
    if ([self validateDetails]) {
        [self.view endEditing:YES];
        [self callWebApiToRequestForLyft];
        
    }
}


-(NSString *)getCountry {
        CTTelephonyNetworkInfo * network_Info = [CTTelephonyNetworkInfo new];
        CTCarrier * carrier = network_Info.subscriberCellularProvider;
        NSString  * countryCode = [carrier.isoCountryCode uppercaseString];
    return countryCode;
}

-(void)getCounrtyListArray{

    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countriesInformation" ofType:@"json"]];
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        [RequestTimeOutView showWithMessage:[NSString stringWithFormat:@"%@",[localError userInfo]] forTime:3.0];
    }else {
        
        
        for (NSDictionary *countryDetailDictionary in parsedObject) {
            CountryDetailModal *obj =  [CountryDetailModal fetchAllCountryDetail:countryDetailDictionary];
            [counrtyArray addObject:[NSString stringWithFormat:@"%@ (%@)",obj.countryPhoneCode,obj.countryName]];
        }
        
        for (NSDictionary *countryDetailDictionary in parsedObject) {
            CountryDetailModal *obj =  [CountryDetailModal fetchAllCountryDetail:countryDetailDictionary];
            
            if ([obj.countryName isEqualToString:countryDialingCode]) {
                loginInfo.strCountryCode = obj.countryPhoneCode;
                [self.countryCodeButton setTitle:[NSString stringWithFormat:@"%@ (%@)",obj.countryPhoneCode,obj.countryName] forState:UIControlStateNormal];
                break;
                
            }
        }
        
    }
}


#pragma mark- Web API

// API FOR THE LYFT
-(void)callWebApiToRequestForLyft{
    
    NSMutableDictionary *valueSignIn = [[NSMutableDictionary alloc] init];

    [valueSignIn setValue:[NSString stringWithFormat:@"%@%@",loginInfo.strCountryCode,loginInfo.strContact] forKey:kpContact];
    [valueSignIn setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kpDeviceTokenid] forKey:kpDeviceTokenid];
    [valueSignIn setValue:kApiLogin forKey:kpAction];
    [valueSignIn setValue:@"ios" forKey:kpDeviceType];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:valueSignIn AndApiType:0 andApiName:nil WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSMutableDictionary *responseData = [result objectForKey:@"responseData"];
            [NSUSERDEFAULT setObject:[responseData objectForKey:kpUserid] forKey:kpUserid];
            
            NSString *name = [NSString stringWithFormat:@"%@ %@",[responseData objectForKeyNotNull:@"first_name" expectedObj:@""],[responseData objectForKeyNotNull:@"last_name" expectedObj:@""]];
            
            [NSUSERDEFAULT setValue:name forKey:kpUserName];
            [NSUSERDEFAULT setBool:YES forKey:kIsLoggedIn];
            [NSUSERDEFAULT synchronize];
            
            [self.navigationController pushViewController:[APPDELEGATE addRevealView] animated:YES];
        }
        else if([[result objectForKey:@"responseCode"] integerValue] == 203)
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   NSMutableDictionary *responseData = [result objectForKey:@"responseData"];
                                                   
                                                   [NSUSERDEFAULT setValue:[responseData objectForKey:kpUserid] forKey:kpUserid];
                                                   [NSUSERDEFAULT synchronize];
                                                   FFVirfyViewController *ConfirmVC = [[FFVirfyViewController alloc]initWithNibName:@"FFVirfyViewController" bundle:nil];
                                                   ConfirmVC.phoneNumber = loginInfo.strContact;
                                                   ConfirmVC.code = loginInfo.strCountryCode;
                                                   [self.navigationController pushViewController:ConfirmVC animated:YES];
                                                   
                                               }];
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


#pragma mark - UIButton Action Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
