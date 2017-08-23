//
//  FFPaymentMethodViewController.m
//  FairFare
//
//  Created by Sarvada Chauhan on 8/4/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//
#import "AppDelegate.h"
#import "FFPaymentMethodViewController.h"
#import "UserInfo.h"
#import "FFPaymentTableViewCell.h"
#import "FFAddCardViewController.h"
@interface FFPaymentMethodViewController ()<UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,requestRideControllerDelegate> {
    UserInfo *paymentInfo;
    NSMutableArray *cardArray;
    
}
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;

@end

@implementation FFPaymentMethodViewController

#pragma mark - View Controller Life Cycle Method
- (void)viewDidLoad {
     self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    
    [self customInit];
}

#pragma mark - Helper Methods
-(void)customInit {
    [self.paymentTableView registerNib:[UINib nibWithNibName:@"FFPaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"FFPaymentTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dataDismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissStatusData) name:@"dataDismiss" object:nil];

    cardArray = [[NSMutableArray alloc] init];
    self. paymentTableView.tableFooterView = _footerView;
    paymentInfo = [[UserInfo alloc]init];
    paymentInfo.cardNumber = @"";
    [self callWebApiToGetPaymentInfo];
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self callWebApiToGetPaymentInfo];

}

-(void) dismissStatusData {
    if (self.isFromPayment) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataRefresh" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
                [self.delegate dismissToHomeController];
            }
            
        }];
    }
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FFPaymentTableViewCell *cell = (FFPaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FFPaymentTableViewCell" ];
    _paymentTableView.delegate = self;
    _paymentTableView.dataSource = self;
    ModalPaymentInfo *payMentInfo = [cardArray objectAtIndex:indexPath.row];
    
    if ([payMentInfo.strPaymentMethodName isEqualToString:@"Visa"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"stp_card_visa1"]];
    }else if ([payMentInfo.strPaymentMethodName isEqualToString:@"Mastercard"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"stp_card_mastercard1"]];

    }else if ([payMentInfo.strPaymentMethodName isEqualToString:@"JCB"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"stp_card_jcb1"]];
        
    }else if ([payMentInfo.strPaymentMethodName isEqualToString:@"Amex"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"stp_card_amex1"]];
        
    }else if ([payMentInfo.strPaymentMethodName isEqualToString:@"Discover"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"stp_card_discover1"]];
        
    }else if ([payMentInfo.strPaymentMethodName isEqualToString:@"DinersClub"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"stp_card_diners1"]];
        
    }else if ([payMentInfo.strPaymentMethodName isEqualToString:@"Invalid"]) {
        [cell.paymentImageView setImage:[UIImage imageNamed:@"card"]];
        
    }else{
        [cell.paymentImageView setImage:[UIImage imageNamed:@"card"]];
    }
    
    
    cell.paymentLabel.tag = 100 + indexPath.row;
    cell.paymentLabel.tag = 100;
    cell.selectionStyle = NO;

    //NSString *cardName = payMentInfo.strPaymentMethodName;
    cell.paymentLabel.text = payMentInfo.strPaymentCardNumber;
    
    
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isFromPayment) {
        ModalPaymentInfo *payMentInfo = [cardArray objectAtIndex:indexPath.row];
        FFAddCardViewController *addCardVC = [[FFAddCardViewController alloc]initWithNibName:@"FFAddCardViewController" bundle:nil];
        addCardVC.obj = payMentInfo;
        addCardVC.str_amount = self.strAmount;
        addCardVC.isFromPayment = YES;
        [self.navigationController pushViewController:addCardVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        ModalPaymentInfo *payMentInfo = [cardArray objectAtIndex:indexPath.row];
        [self callWebApiToDeleteCard:payMentInfo.strPaymentId];
    }
}
#pragma mark - Memory Management Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIButton Action Method
- (IBAction)backButtonAction:(UIButton *)sender {
    
    if (self.isFromPayment) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataRefresh" object:nil];

        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
                [self.delegate dismissToHomeController];
            }
            
        }];
    }
    
    
    
   
}

-(void)dismissRequestRideController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewCardBtnAction:(UIButton *)sender {
    FFAddCardViewController *addCardVC = [[FFAddCardViewController alloc]initWithNibName:@"FFAddCardViewController" bundle:nil];
    [self.navigationController pushViewController:addCardVC animated:YES];
}


#pragma mark- Web API

-(void)callWebApiToGetPaymentInfo{
    
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:@"card_detail_list" forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:valueProfile AndApiType:0 andApiName:nil WithComptionBlock:^(id result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
        
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [cardArray removeAllObjects];
            cardArray = [ModalPaymentInfo getPaymentMethodDetails: [result objectForKeyNotNull:@"card_detals" expectedObj:[NSArray array]]];
                [self.paymentTableView reloadData];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 0)
        {
            [cardArray removeAllObjects];
            [self.paymentTableView reloadData];
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    }];
    
}


-(void)callWebApiToDeleteCard:(NSString *)deleteId{
    
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:deleteId forKey:@"card_id"];
    [valueProfile setValue:@"card_detail_delete" forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:valueProfile AndApiType:0 andApiName:nil WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self callWebApiToGetPaymentInfo];
            }];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:kResponseMessage] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    }];
    
}

@end
