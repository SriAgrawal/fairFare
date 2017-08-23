//
//  FFAddCardViewController.m
//  FairFare
//
//  Created by Ram Chandra on 04/08/17.
//  Copyright © 2017 Ram Chandra. All rights reserved.
//

#import "FFAddCardViewController.h"
#import "FFPaymentMethodViewController.h"
#import <Stripe/Stripe.h>
#import "RequestTimeOutView.h"
#import "UserInfo.h"
#import "LTHMonthYearPickerView.h"
#import "AESCrypt.h"
#import "Header.h"
#import "Luhn.h"
@interface FFAddCardViewController ()<UITextFieldDelegate, UIPickerViewDelegate, LTHMonthYearPickerViewDelegate,FFAuthenticateUserDelegate>
{
    ModalPaymentInfo *paymentInfo;
    CGRect kbHeight;
    NSString *strYear;
    NSString *strMonth;
    NSMutableArray *soureMonth;
    NSMutableDictionary* myDict;
    NSString *cardType;

}
@property (weak, nonatomic) IBOutlet UIButton *expiryButtton;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *expiryDateTF;
@property (nonatomic, strong) LTHMonthYearPickerView *monthYearPicker;
@property (weak, nonatomic) IBOutlet UILabel *navLabel;
@end

@implementation FFAddCardViewController

# pragma mark - ViewController Life Cycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    myDict = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[NSUSERDEFAULT valueForKey:@"data"]];
    paymentInfo = [[ModalPaymentInfo alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM"];
    strMonth = [df stringFromDate:[NSDate date]];
    
    [df setDateFormat:@"YYYY"];
    strYear = [df stringFromDate:[NSDate date]];
    
    int month = [strMonth  intValue];
    int year = [strYear  intValue];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM /yyyy"];
    NSDate *initialDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", month, year]];
    int maxYear = year+100;
    NSDate *maxDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", month, maxYear]];
    
    _monthYearPicker = [[LTHMonthYearPickerView alloc]
                        initWithDate: initialDate
                        shortMonths: NO
                        numberedMonths: NO
                        andToolbar: YES
                        minDate:[NSDate date]
                        andMaxDate:maxDate];
    _monthYearPicker.delegate = self;
    _monthYearPicker.backgroundColor=[UIColor whiteColor];

    [self CustomInit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
# pragma mark - Helper methods
-(void)CustomInit {
    
    if (self.isFromPayment) {
        self.navLabel.text = @"Payment";
    }
    else{
        self.navLabel.text = @"Add New Card";
    }
    paymentInfo.strPaymentCardNumber = self.obj.strPaymentCardNumber;
    paymentInfo.strPaymentId = self.obj.strPaymentId;
    paymentInfo.strCardate = self.obj.strCardate;
    paymentInfo.strCvv = @"";
    paymentInfo.strOriginalCardNumber = self.obj.strOriginalCardNumber;
    self.cardNumberTextField.text = paymentInfo.strPaymentCardNumber;
    self.expiryDateTF.text = paymentInfo.strCardate;
}
-(NSString *)validateDetails{
    
    if(!paymentInfo.strOriginalCardNumber.length)
    {
        return @"*Please enter your card number.";
    }
    else if(paymentInfo.strOriginalCardNumber.length < 15)
    {
        return @"*Card number should be minimum of 15 digits.";
    }
    else if(!_expiryDateTF.text.length)
    {
        return @"*Please select the expiry date of your card.";
    }
    else if(!_cvvTextField.text.length)
    {
        return @"*Please enter your CVV number.";
    }
    else if([_cvvTextField.text length] < 3)
    {
        return @"*please enter at least three digits of CVV.";
    }
    else
        return @"";
}

#pragma mark - Textfield delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(!string.length)
    {
        return true;
    }
    if(textField == _cardNumberTextField)
    {
        if(textField.text.length >= 17)
        {
            return NO;
        }
    }
    if(textField == _cvvTextField)
    {
        if(textField.text.length >=4)
        {
            return NO;
        }
    }
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch(textField.tag)
    {
        case 100:
            paymentInfo.strOriginalCardNumber = textField.text;
            break;
        case 101:
            paymentInfo.strCardate = textField.text;
            break;
        case 102:
            paymentInfo.strCvv = textField.text;
            break;

            default:
            break;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 101) {
        
    }else{
        if (self.isFromPayment) {
            textField.inputAccessoryView= toolBarForNumberPad(self,@"PAY");
        }
        else{
        textField.inputAccessoryView= toolBarForNumberPad(self,@"ADD CARD");
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 101){
        self.expiryDateTF.inputView = _monthYearPicker;
    }
}

#pragma mark - Date Picker-
//***************************************************

- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues {
    UITextField *dateTextField = (UITextField *)[self.view viewWithTag:102];
    dateTextField.text = [NSString stringWithFormat:
                          @"%@ / %@",
                          initialValues[@"month"],
                          initialValues[@"year"]];
    [dateTextField resignFirstResponder];
}


- (void)pickerDidPressDoneWithMonth:(NSInteger)month andYear:(NSString *)year {
    
    UITextField *dateTextField = (UITextField *)[self.view viewWithTag:101];
    NSString *selectedMonth = [NSString stringWithFormat: @"%ld", (long)month];
    
    
    dateTextField.text=[NSString stringWithFormat:@"%@/%@",selectedMonth,year];
    paymentInfo.strCardate =[NSString stringWithFormat:@"%@/%@",selectedMonth,year];
    [dateTextField resignFirstResponder];
}


- (void)pickerDidPressCancel {
    
    UITextField *dateTextField = (UITextField *)[self.view viewWithTag:101];
    [dateTextField resignFirstResponder];
}

#pragma mark - UIButton Action Method
- (IBAction)datePickerCancelAction:(id)sender {
    [self.view endEditing:YES];
    
}

- (IBAction)showDatePicker:(UIButton *)sender {
    
    [self.expiryDateTF becomeFirstResponder];
}
- (IBAction)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneWithNumberPad{
    
    [self.view endEditing:YES];
    NSString *errorMessage = [self validateDetails];
    if(errorMessage.length)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if (self.isFromPayment) {
            [self getStripeToken];
        }
        else{
            cardType  = [self determiningCardTypeBasedOnCardNumber:paymentInfo.strOriginalCardNumber];
            [self callApiSaveCard:@"" :cardType];
        }
    }
}


- (NSString *)determiningCardTypeBasedOnCardNumber : (NSString *)strCardNumber {
    
    NSString *strCardType = @"";
    OLCreditCardType typeOfCardEnum = [Luhn typeFromString:strCardNumber];
    
    switch (typeOfCardEnum) {
            
        case OLCreditCardTypeMastercard:
            strCardType = @"Mastercard";
            break;
        case OLCreditCardTypeVisa:
            strCardType = @"Visa";
            break;
        case OLCreditCardTypeJCB:
            strCardType = @"JCB";
            break;
        case OLCreditCardTypeAmex:
            strCardType = @"Amex";
            break;
        case OLCreditCardTypeDiscover:
            strCardType = @"Discover";
            break;
        case OLCreditCardTypeDinersClub:
            strCardType = @"DinersClub";
            break;
        case OLCreditCardTypeInvalid:
            strCardType = @"Invalid";
            break;
        case OLCreditCardTypeUnsupported:
            strCardType = @"Unsupported";
            break;
        default:
            break;
    }
    return strCardType;
}

-(void)didReceiveAccessToken:(NSString *)accessToken{
    
    [NSUSERDEFAULT setValue:accessToken forKey:kAccess_token];
    [NSUSERDEFAULT setValue:[myDict valueForKey:@"strPickMe"] forKey:kStartCoordinate];
    [NSUSERDEFAULT setValue:[myDict valueForKey:@"strTakeMeTo"]forKey:kEndCoordinate];
    [NSUSERDEFAULT synchronize];
    
    FFRequestForRideVC *objVC = [[FFRequestForRideVC alloc]initWithNibName:@"FFRequestForRideVC" bundle:nil];
    [objVC setIsForBookRide:YES];
    [objVC setProdict_id:[myDict valueForKey:@"product_id"]];
    [objVC setRide_type:[myDict valueForKey:@"rideType"]];
    [objVC setServiceName:[myDict valueForKey:@"serviceName"]];
    [self.navigationController pushViewController:objVC animated:YES];
}


-(void)getStripeToken {

    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];
    NSArray *expiryDateArray = [self.obj.strCardate componentsSeparatedByString:@"/"];
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    cardParams.number = paymentInfo.strOriginalCardNumber;
    cardParams.expMonth = [[expiryDateArray firstObject] integerValue];
    cardParams.expYear = [[expiryDateArray lastObject] integerValue];
    cardParams.cvc = paymentInfo.strCvv;
    
 //Stripe Test Key   pk_test_0szOR0mgDtmkmoSGsDN3oKsW
    //Stripe Live Key   pk_live_n5SSWHN1MllRlGASUq5EiCCZ


    STPAPIClient* client =   [[STPAPIClient sharedClient] initWithPublishableKey:@"pk_test_0szOR0mgDtmkmoSGsDN3oKsW"];
    [client
     createTokenWithCard:cardParams
     completion:^(STPToken *token, NSError *error) {
         if (token) {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             // TODO: send the token to your server so it can create a charge
           //  NSLog(@"%@",token);
             [self callApiMakePayment:paymentInfo.strPaymentId  token:[NSString stringWithFormat:@"%@",token]];
         } else {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [RequestTimeOutView showWithMessage:[error.userInfo objectForKeyNotNull:@"NSLocalizedDescription" expectedObj:@""] forTime:4];
         }
         if(error){
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            // [RequestTimeOutView showWithMessage:error.description forTime:4];
             [RequestTimeOutView showWithMessage:[error.userInfo objectForKeyNotNull:@"NSLocalizedDescription" expectedObj:@""] forTime:4];

         }
         
     }];
}

#pragma mark - WebApi Method



-(void)callApiMakePayment: (NSString *)cardID token:(NSString *)token {


    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSArray* pickMeCoordinateArray = [[myDict valueForKey:@"strPickMe"] componentsSeparatedByString: @","];
    NSString *pickMeLat = [pickMeCoordinateArray objectAtIndex: 0];
    NSString *pickMeLong = [pickMeCoordinateArray objectAtIndex: 1];
    
    NSArray* takeMeCoordinateArray = [[myDict valueForKey:@"strTakeMeTo"] componentsSeparatedByString: @","];
    NSString *takeMeLat = [takeMeCoordinateArray objectAtIndex: 0];
    NSString *takeMeLong = [takeMeCoordinateArray objectAtIndex: 1];
    
    
    [params setValue:[NSString stringWithFormat:@"%@", pickMeLat] forKey:@"user_source_lat"];
    [params setValue:[NSString stringWithFormat:@"%@", pickMeLong] forKey:@"user_source_long"];
    [params setValue:[NSString stringWithFormat:@"%@", takeMeLat] forKey:@"user_destination_lat"];
    [params setValue:[NSString stringWithFormat:@"%@", takeMeLong] forKey:@"user_destination_long"];
    
    [params setValue:[myDict valueForKey:@"totalAmount"] forKey:@"totalAmount"];
    [params setValue:[myDict valueForKey:@"pickAddress"] forKey:@"pickAddress"];
    [params setValue:[myDict valueForKey:@"takeAddress"] forKey:@"takeAddress"];

    [params setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [params setValue:self.str_amount forKey:@"amount"];
    [params setValue:@"payment_stripe" forKey:kpAction];
    [params setValue:token forKey:@"token"];
    [params setValue:@"" forKey:@"promocode"];
    [params setValue:cardID forKey:@"card_id"];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:params AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error)
     {
         if([[result objectForKey:@"responseCode"] integerValue] == 200)
         {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                 FFAuthenticateUserVC *objVC = [[FFAuthenticateUserVC alloc]initWithNibName:@"FFAuthenticateUserVC" bundle:nil];
                 [objVC setDelegate:self];
                 objVC.serviceName = [myDict valueForKey:@"serviceName"];
                 [self presentViewController:objVC animated:YES completion:nil];
             }];
         }
         else if ([[result objectForKey:@"responseCode"] integerValue] == 0)
         {
//             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
//             FFAuthenticateUserVC *objVC = [[FFAuthenticateUserVC alloc]initWithNibName:@"FFAuthenticateUserVC" bundle:nil];
//             [objVC setDelegate:self];
//             objVC.serviceName = [myDict valueForKey:@"serviceName"];
//             [self presentViewController:objVC animated:YES completion:nil];
            
             
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
             }];
         }
         else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
         {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
             }];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
             }];
         }
     }];
}

-(void)callApiSaveCard: (NSString *)nonce :(NSString *)type {
    
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"" forKey:@"nonce"];
    [params setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [params setValue:type forKey:@"card_type"];
    [params setValue:@"card_detail_insert" forKey:kpAction];
    [params setValue:[AESCrypt encrypt:paymentInfo.strCardate password:kpEncryptionKey] forKey:@"card_date"];
    [params setValue:[AESCrypt encrypt:paymentInfo.strOriginalCardNumber password:kpEncryptionKey] forKey:@"card_details"];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:params AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error)
     {
         if([[result objectForKey:@"responseCode"] integerValue] == 200)
         {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                 
                 [self.navigationController popViewControllerAnimated:true];
                 
             }];
             
         }
         else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
         {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
             }];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
             [[AlertView sharedManager]presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
             }];
         }
     }];
}

@end
