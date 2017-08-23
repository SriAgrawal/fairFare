//
//  FFSideMenuViewController.m
//  FairFare
//
//  Created by Lalit on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFSideMenuViewController.h"
#import "FFMenuTableCell.h"
#import "Header.h"
#import "FFProfileViewController.h"

@interface FFSideMenuViewController ()<UITableViewDelegate,UITableViewDataSource,dismissToHomeControllerDelegate,dismissToPaymentDelegate,dismissToFavControllerDelegate,dismissToSettingControllerDelegate,dismissToProfileControllerDelegate,dismissToPromoControllerDelegate>
{
    NSArray *menuArray, *imageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avtarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *historyCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *savedMoneyLbl;

@end

@implementation FFSideMenuViewController


#pragma mark- Life cycle of view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDefaults];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self callViewProfileApi];
    [self setUpDefaults];
}

#pragma mark- Helper Methods

-(void) setUpDefaults {
    
    menuArray = [[NSArray alloc]initWithObjects:@"History",@"Payment",@"Favorites",@"Promo",@"Settings", nil];
    imageArray = [[NSArray alloc]initWithObjects:@"history",@"payment",@"fav",@"promo",@"setting", nil];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    
    _menuTableView.tableHeaderView = _headerView;
    [_menuTableView registerNib:[UINib nibWithNibName:@"FFMenuTableCell" bundle:nil] forCellReuseIdentifier:@"FFMenuTableCell"];
    
}

#pragma mark- UITabelView Delegates and DataSources Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FFMenuTableCell *cell = (FFMenuTableCell *)[tableView dequeueReusableCellWithIdentifier:@"FFMenuTableCell"];
    
    cell.dataLbl.text = menuArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0: {
            
            FFHistoryViewController *historyVC= [[FFHistoryViewController alloc]initWithNibName:@"FFHistoryViewController" bundle:nil];
                   UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:historyVC];
            historyVC.delegate = self;
            [self presentViewController:homeNav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            FFPaymentMethodViewController *historyVC= [[FFPaymentMethodViewController alloc]initWithNibName:@"FFPaymentMethodViewController" bundle:nil];
            UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:historyVC];
            historyVC.delegate = self;
            [self presentViewController:homeNav animated:YES completion:nil];
            
        }
            break;
            
        case 2:
        {
            FFFavouriteViewController *howItWorksVC= [[FFFavouriteViewController alloc]initWithNibName:@"FFFavouriteViewController" bundle:nil];
            UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:howItWorksVC];
            howItWorksVC.delegate = self;
            [self presentViewController:homeNav animated:YES completion:nil];
        
        }
            break;
            
        case 3:
        {
            FFPromoCodeViewController *feedBackVC= [[FFPromoCodeViewController alloc]initWithNibName:@"FFPromoCodeViewController" bundle:nil];
            UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:feedBackVC];
            feedBackVC.delegate = self;
            [self presentViewController:homeNav animated:YES completion:nil];
            
        }
            break;
            
        case 4:
        {
            FFSettingViewController *howItWorksVC= [[FFSettingViewController alloc]initWithNibName:@"FFSettingViewController" bundle:nil];
            UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:howItWorksVC];
            howItWorksVC.delegate = self;
            [self presentViewController:homeNav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


-(IBAction)profileButtonAction: (UIButton *)sender {
    [self.view endEditing:YES];
    FFProfileViewController *howItWorksVC= [[FFProfileViewController alloc]initWithNibName:@"FFProfileViewController" bundle:nil];
    UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:howItWorksVC];
    howItWorksVC.delegate = self;
    [self presentViewController:homeNav animated:YES completion:nil];
    
}


-(void) dismissToHomeController{
    
    FFHomeViewController *howItWorksVC= [[FFHomeViewController alloc]initWithNibName:@"FFHomeViewController" bundle:nil];
    UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:howItWorksVC];
    [self.sidePanelController setCenterPanel:homeNav];

}


-(void)dismissToHomePushToFareController:(FFHistoryInfo *)objHistory {
    
    ModalHome * obj = [[ModalHome alloc] init];
    obj.strPickAddress = objHistory.fromAddress;
    obj.strPickLat = objHistory.fromAddressLat;
    obj.strPickLong = objHistory.fromAddressLong;
    obj.strTakeAddress = objHistory.toAddress;
    obj.strTakeLat = objHistory.toAddressLat;
    obj.strTakeLong = objHistory.toAddressLong;

    
    FFHomeViewController *howItWorksVC= [[FFHomeViewController alloc]initWithNibName:@"FFHomeViewController" bundle:nil];
    howItWorksVC.isFromHistory =YES;
    howItWorksVC.modalObjNew = obj;
    UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:howItWorksVC];
    [self.sidePanelController setCenterPanel:homeNav];
    
    }



-(void) dismissToHomeController:(BOOL)isLogout{
    
    if (isLogout) {
        for (UIViewController* viewController in [APPDELEGATE navController].viewControllers)
                    {
                        if ([viewController isKindOfClass:[FFLoginViewController class]] )
                        {
                                         [NSUSERDEFAULT removeObjectForKey:kpUserid];
                                         [NSUSERDEFAULT removeObjectForKey:kpSocialId];
                                         [NSUSERDEFAULT setBool:NO forKey:kIsLoggedIn];
                                         [NSUSERDEFAULT synchronize];
                                         [APPDELEGATE stopLocation];
                                         [[APPDELEGATE navController] popToViewController:viewController animated:NO];
                            }
                                     
                        }
    }
    else{
    FFHomeViewController *howItWorksVC= [[FFHomeViewController alloc]initWithNibName:@"FFHomeViewController" bundle:nil];
    UINavigationController *homeNav=[[UINavigationController alloc] initWithRootViewController:howItWorksVC];
    [self.sidePanelController setCenterPanel:homeNav];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Web Api Method
-(void)callViewProfileApi
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:kApiMyProfile forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSMutableDictionary *responseData = [result objectForKey:@"responseData"];
            NSString *imageProfile = [responseData objectForKeyNotNull:@"image" expectedObj:@""];
            NSString *name = [NSString stringWithFormat:@"%@ %@",[responseData objectForKeyNotNull:@"first_name" expectedObj:@""],[responseData objectForKeyNotNull:@"last_name" expectedObj:@""]];

           [self.avtarImgView setImageWithURL:[NSURL URLWithString:imageProfile] placeholderImage:[UIImage imageNamed:@"profile_placeholder"]];
            self.nameLbl.text = [imageProfile length] ? name : @"Welcome";
            self.historyCountLbl.text = [imageProfile length] ? [NSString stringWithFormat:@"%@ rides",[responseData objectForKeyNotNull:@"rideCount" expectedObj:@""]] : @"Update";
             self.savedMoneyLbl.hidden = [imageProfile length] ? NO : YES;
            self.savedMoneyLbl.text = [[responseData objectForKeyNotNull:@"saveMoney" expectedObj:@""] length] ? [NSString stringWithFormat:@"$%@ saved",[responseData objectForKeyNotNull:@"saveMoney" expectedObj:@""]] : @"";
            [NSUSERDEFAULT setObject:name forKey:kpUserName];

        } else
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
    }];
}


@end
