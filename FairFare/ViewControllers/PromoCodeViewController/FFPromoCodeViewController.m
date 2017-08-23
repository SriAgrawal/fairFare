//
//  FFPromoCodeViewController.m
//  FairFare
//
//  Created by Shridhar Agarwal on 09/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFPromoCodeViewController.h"
#import "Header.h"
#import "FFPromoCodeTableViewCell.h"

@interface FFPromoCodeViewController () {
    
    NSMutableArray *arrayPromoCode;
    
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *promoTableView;
@property (weak, nonatomic) IBOutlet UITextField *promoTextField;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint_bottomView;

@end

@implementation FFPromoCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayPromoCode = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    [_promoTextField setPlaceholder:@"Enter promo code"];
    [_promoTextField becomeFirstResponder];
     [self.promoTableView registerNib:[UINib nibWithNibName:@"FFPromoCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FFPromoCodeTableViewCell"];
    
    [self callWebApiToGetPromoCodeList];
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


#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayPromoCode.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFPromoCodeTableViewCell *cell = (FFPromoCodeTableViewCell *)[self.promoTableView dequeueReusableCellWithIdentifier:NSStringFromClass([FFPromoCodeTableViewCell class])];
   
    [cell.labelCell setText:[arrayPromoCode objectAtIndex:indexPath.row]];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}


- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
            [self.delegate dismissToHomeController];
        }
    }];

   
}


- (IBAction)addButtonAction:(id)sender {
    
    if (self.promoTextField.text.length) {
        [self callWebApiToApplyPromoCode];
        
    }else {
        [AlertController title:@"" message:@"Please enter promo code." andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            
        }];
    }
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    
    NSString *strText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    if (strText.length > 15)
        return NO;
    else
        return YES;
    
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


#pragma mark- Web API
-(void)callWebApiToApplyPromoCode{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];

    [paramDict setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [paramDict setValue:@"add_promocode" forKey:@"action"];
    [paramDict setValue:self.promoTextField.text forKey:@"promocode"];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:0 andApiName:nil WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self.promoTextField setText:@""];
                [self callWebApiToGetPromoCodeList];
            }];
            
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 0)
        {
            
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self.promoTextField setText:@""];
            }];
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
            }];
        }
    }];
}

-(void)callWebApiToGetPromoCodeList{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    
    [paramDict setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [paramDict setValue:@"list_promo_code" forKey:@"action"];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:0 andApiName:nil WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [arrayPromoCode removeAllObjects];
            
            
            NSString *code = [result objectForKeyNotNull:@"promo_list" expectedObj:@""];
            
            if (code.length) {
                [arrayPromoCode addObject:code];

            }

            [self.promoTableView reloadData];
            
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 0)
        {
            
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
            }];
            
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
            }];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
