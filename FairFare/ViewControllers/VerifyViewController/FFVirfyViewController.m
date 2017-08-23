//
//  FFLoginViewController.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 03/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFVirfyViewController.h"
#import "Header.h"

@interface FFVirfyViewController (){
    UserInfo *loginInfo;
    NSTimer* myTimer;
    NSInteger timerValue;
    UIButton *toolButton;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PATextField *firstTextFields;
@property (weak, nonatomic) IBOutlet PATextField *secondTextFields;
@property (weak, nonatomic) IBOutlet PATextField *thirdTextFields;
@property (weak, nonatomic) IBOutlet PATextField *fourthTextFields;
@property (weak, nonatomic) IBOutlet PATextField *fiveTextFields;
@property (weak, nonatomic) IBOutlet PATextField *sixTextFields;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorFirstLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorSecondLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorThridLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorFourthLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorFifthLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorSixthLineLabel;

@property (weak, nonatomic) NSString* accessCode;
@end

@implementation FFVirfyViewController

#pragma mark- Life cycle of view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting up the Intial Setup MethoD
    [self initialSetUp];
}

-(void)initialSetUp{
    
    self.tableView.tableHeaderView = self.headerView;
    loginInfo = [[UserInfo alloc] init];
    //Manage the error label
    _errorMessageLabel.text = [NSString stringWithFormat:@"The code was sent to (%@)%@",self.code, self.phoneNumber];
    //Setting the View on the keyboard as toolbar view
    self.firstTextFields.inputAccessoryView = setToolbarViewCustomNew(self);
    self.secondTextFields.inputAccessoryView = setToolbarViewCustomNew(self);
    self.thirdTextFields.inputAccessoryView = setToolbarViewCustomNew(self);
    self.fourthTextFields.inputAccessoryView = setToolbarViewCustomNew(self);
    self.fiveTextFields.inputAccessoryView = setToolbarViewCustomNew(self);
    self.sixTextFields.inputAccessoryView = setToolbarViewCustomNew(self);
    [self.firstTextFields becomeFirstResponder];
}

UIView* setToolbarViewCustomNew(id controller){
    if ([controller isKindOfClass:[FFVirfyViewController class]]) {
        
        UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
        [numberToolbar setBackgroundColor:[UIColor clearColor]];
        UIButton* leftBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        leftBarButton.tag = 2003;
        [leftBarButton setTitle:@"Resend" forState:UIControlStateNormal];
        [leftBarButton.titleLabel setFont:AppFont(15)];
        leftBarButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftBarButton addTarget:controller action:@selector(resendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        //[rightBarButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        
        UIButton* rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-60, 0, 50, 50)];
        [rightBarButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [rightBarButton addTarget:controller action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
        [numberToolbar addSubview:leftBarButton];
        [numberToolbar addSubview:rightBarButton];
        return numberToolbar;
        
    }
    UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    [numberToolbar setBackgroundColor:[UIColor clearColor]];
    UIButton* rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-60, 0, 50, 50)];
    [rightBarButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [rightBarButton addTarget:controller action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [numberToolbar addSubview:rightBarButton];
    return numberToolbar;
}






-(BOOL)validateDetails{

    if(!(self.firstTextFields.text.length) && !(self.secondTextFields.text.length) && !(self.thirdTextFields.text.length) && !(self.fourthTextFields.text.length) && !(self.fiveTextFields.text.length) && !(self.sixTextFields.text.length)){
        self.errorMessageLabel.hidden = NO;
            [UIView transitionWithView:self.errorMessageLabel
                              duration:0.70f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.errorMessageLabel.text = KAlert_BLANKCODE;
                            } completion:nil];
        self.errorFirstLineLabel.backgroundColor = [UIColor redColor];
        self.errorSecondLineLabel.backgroundColor = [UIColor redColor];
        self.errorThridLineLabel.backgroundColor = [UIColor redColor];
        self.errorFourthLineLabel.backgroundColor = [UIColor redColor];
        self.errorFifthLineLabel.backgroundColor = [UIColor redColor];
        self.errorSixthLineLabel.backgroundColor = [UIColor redColor];
        return NO;
    }
    else if (!(self.firstTextFields.text.length)) {
        self.errorMessageLabel.hidden = NO;
        self.errorFirstLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_BLANKFIRSTCODE;
        return NO;
    }
    else if (!(self.secondTextFields.text.length)) {
        self.errorMessageLabel.hidden = NO;
        self.errorSecondLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_BLANKSECONDCODE;
        return NO;
    }
    else if (!(self.thirdTextFields.text.length)) {
        self.errorMessageLabel.hidden = NO;
        self.errorThridLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_BLANKTHIRDCODE;
        return NO;
    }
    else if (!(self.fourthTextFields.text.length)) {
        self.errorMessageLabel.hidden = NO;
        self.errorFourthLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_BLANKFOURTHCODE;
        return NO;
    }
    else if (!(self.fiveTextFields.text.length)) {
        self.errorMessageLabel.hidden = NO;
        self.errorFifthLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_BLANKFIVECODE;
        return NO;
    }
    else if (!(self.sixTextFields.text.length)) {
        self.errorMessageLabel.hidden = NO;
        self.errorSixthLineLabel.backgroundColor = [UIColor redColor];
        self.errorMessageLabel.text = KAlert_BLANKSIXCODE;
        return NO;
    }
    else{
        _accessCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",self.firstTextFields.text,self.secondTextFields.text,self.thirdTextFields.text,self.fourthTextFields.text,_fiveTextFields.text,self.sixTextFields.text];
    return YES;
    }
}

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//
//    if (textField.tag == 6) {
//        self.sixTextFields.inputAccessoryView = setToolbarViewCustom(self);
//    }else{
//        self.sixTextFields.inputAccessoryView = nil;
//    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _errorMessageLabel.text = [NSString stringWithFormat:@"The code was sent to (%@)%@", self.code,self.phoneNumber];
    self.errorFirstLineLabel.backgroundColor = [UIColor whiteColor];
    self.errorSecondLineLabel.backgroundColor = [UIColor whiteColor];
    self.errorThridLineLabel.backgroundColor = [UIColor whiteColor];
    self.errorFourthLineLabel.backgroundColor = [UIColor whiteColor];
    self.errorFifthLineLabel.backgroundColor = [UIColor whiteColor];
    self.errorSixthLineLabel.backgroundColor = [UIColor whiteColor];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    
    NSString *newTextToBe = [[textField text] stringByReplacingCharactersInRange:range withString:string];

    //return (textField.text.length >=1 && range.length == 0)? NO : YES;
    
    if (textField.tag == 1 && newTextToBe.length >1) {
        [self.secondTextFields becomeFirstResponder];
        return NO;
    }else if (textField.tag == 2 && newTextToBe.length >1) {
        [self.thirdTextFields becomeFirstResponder];

        return NO;

    }else if (textField.tag == 3 && newTextToBe.length >1) {
        [self.fourthTextFields becomeFirstResponder];

        return NO;
        
    }
    else if (textField.tag == 4 && newTextToBe.length >1) {
        [self.fiveTextFields becomeFirstResponder];

        return NO;
    }else if (textField.tag == 5 && newTextToBe.length >1) {
        [self.sixTextFields becomeFirstResponder];

        return NO;
    }else if (textField.tag == 6 && newTextToBe.length >1) {
       // [self.sixTextFields resignFirstResponder];
        return NO;
        
    }
    
    else if (([textField.text length] <= 1) && ([newTextToBe length] > 0)){
        
        NSInteger tagNew = textField.tag +1;
        
        UITextField *nextText  = (UITextField*)[self.view viewWithTag:tagNew];
        textField.text = newTextToBe;

        if (nextText == nil) {
            //[textField resignFirstResponder];
        }
        [nextText becomeFirstResponder];
        return NO;
        
    } else if ((textField.text.length >= 1) && ([newTextToBe length] == 0)){
        
        NSInteger tagNew = textField.tag -1;
        
        UITextField *preText  = (UITextField*)[self.view viewWithTag:tagNew];
        
        if (preText == nil) {
            preText  = (UITextField*)[self.view viewWithTag:1];
        }
        textField.text = @"";
        [preText becomeFirstResponder];
        return NO;
        
    }
    
    return YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   loginInfo.strContact = textField.text;
}

#pragma mark - UIButton Action Methodd

- (void)doneWithNumberPad{
    
    if ([self validateDetails]) {
        [self callWebApiToRequestForVerifyCode];
    }
}
- (void)resendCodeAction :(UIButton *)sender
{
    toolButton = sender;// [self.view endEditing:YES];
    [self callResendCodeApi];
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Service Api method

-(void)callWebApiToRequestForVerifyCode{
    
    NSMutableDictionary *valueCode = [[NSMutableDictionary alloc] init];
    [valueCode setObject:_accessCode forKey:kpConfirmationCode];
    [valueCode setObject:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [valueCode setObject:@"confirmation_code" forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueCode AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [self.view endEditing:YES];
            [NSUSERDEFAULT setBool:YES forKey:kIsLoggedIn];
            [NSUSERDEFAULT synchronize];
            [self.navigationController pushViewController:[APPDELEGATE addRevealView] animated:YES];
        } else
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
    }];
    
}
-(void)callResendCodeApi{
    
    NSMutableDictionary *valueCode = [[NSMutableDictionary alloc] init];
    [valueCode setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [valueCode setObject:@"resend_code" forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueCode AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   
                                               }];
            
            
        }
        else if([[result objectForKey:@"responseCode"] integerValue] == 203)
        {
            [myTimer invalidate];
            timerValue = 30;
            myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                     selector: @selector(callAfterThirtySecond) userInfo: nil repeats: YES];
            
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
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


-(void)callAfterThirtySecond {
    
    
    if (timerValue != 0) {

            [toolButton setTitle:[NSString stringWithFormat:@"Resend in %ld sec",(long)timerValue] forState:UIControlStateNormal];
        [toolButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5] forState:UIControlStateNormal];

        toolButton.enabled = NO;
        timerValue--;
        
    } else {
        [myTimer invalidate];
        [toolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [toolButton setTitle:@"Resend" forState:UIControlStateNormal];
        toolButton.enabled = YES;


    }

    
}

@end
