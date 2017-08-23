//
//  FFSettingViewController.m
//  FairFare
//
//  Created by Lalit on 04/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFSettingViewController.h"
#import "Header.h"

@interface FFSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *generalArray;
    NSArray *legalArray;
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;


@end

@implementation FFSettingViewController


#pragma mark- Life cycle of view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDefaults];
}

#pragma mark- Helper Methods

-(void) setUpDefaults {
    
    self.navigationController.navigationBar.hidden = YES;
    legalArray = [[NSArray alloc]initWithObjects:@"About App",@"Terms & Conditions",@"Updates", @"Logout",nil];
    
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    
    [_settingTableView registerNib:[UINib nibWithNibName:@"FFSettingTableCell" bundle:nil] forCellReuseIdentifier:@"FFSettingTableCell"];
}


#pragma mark- UITabelView Delegates and DataSources Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return legalArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FFSettingTableCell *cell = (FFSettingTableCell *)[tableView dequeueReusableCellWithIdentifier:@"FFSettingTableCell"];
    
    if (indexPath.section == 0) {
        cell.dataLbl.text = @"Account";
    }else{
        cell.dataLbl.text = legalArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 150, 20)];
    
    lbl.text = section == 0 ? @"General" : @"Legal";
    lbl.font = AppFont(12);
    lbl.textColor = [UIColor lightGrayColor];
    [view addSubview:lbl];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //Account
        [self.view endEditing:YES];
        FFProfileViewController *howItWorksVC= [[FFProfileViewController alloc]initWithNibName:@"FFProfileViewController" bundle:nil];
        howItWorksVC.isFromSetting = YES;
        [self.navigationController pushViewController:howItWorksVC animated:YES];
    }
    else{
        switch (indexPath.row)
        {
            case 0: {
                FFPrivacyPolicyVC *howItWorksVC= [[FFPrivacyPolicyVC alloc]initWithNibName:@"FFPrivacyPolicyVC" bundle:nil];
                howItWorksVC.navigationtitle=@"About App";
                howItWorksVC.isValid=YES;
                [self.navigationController pushViewController:howItWorksVC animated:YES];
            }
                break;
            case 1:
            {
                FFPrivacyPolicyVC *howItWorksVC= [[FFPrivacyPolicyVC alloc]initWithNibName:@"FFPrivacyPolicyVC" bundle:nil];
                howItWorksVC.navigationtitle=@"Terms & Conditions";
                howItWorksVC.isValid=YES;
               [self.navigationController pushViewController:howItWorksVC animated:YES];
                
            }
                break;
                
            case 2:
            {
                //Update
                
            }
                break;
                
            case 3:
            {//Logout
                [self logout];
                
            }
                break;
            default:
                break;
        }

    
    }
   }


//Helper Method
-(void)logout{
    
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to logout?" andButtonsWithTitle:@[@"Yes",@"No"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if (index == 0)
        {
            NSMutableDictionary *valueLogout = [[NSMutableDictionary alloc] init];
            [valueLogout setObject:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
            [valueLogout setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kpDeviceTokenid] forKey:kpDeviceTokenid];
            [valueLogout setObject:kApiLogout forKey:kpAction];
            [valueLogout setObject:@"ios" forKey:kpDeviceType];
            
            [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueLogout AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error)
             {
                 if([[result objectForKey:@"responseCode"] integerValue] == 200)
                 {
                     [self dismissViewControllerAnimated:YES completion:^{
                         if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
                             [NSUSERDEFAULT removeObjectForKey:kIsLoggedIn];
                             [self.delegate dismissToHomeController:YES];
                         }
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
    }];
}
#pragma mark- UIButton Actions

- (IBAction)backBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
            [self.delegate dismissToHomeController:NO];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
