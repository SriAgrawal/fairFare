//
//  FFDriverViewController.m
//  FairFareApp
//
//  Created by Shridhar Agarwal on 28/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFDriverViewController.h"
#import "Header.h"


@interface FFDriverViewController (){
    
    ModalInvoice *obj;
    NSMutableArray *dataSourceArray,*driverTitleArray, *driverValueArray;
}
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *driverTableView;
@property (weak, nonatomic) IBOutlet UIImageView *driverImageView;

@end

@implementation FFDriverViewController

#pragma mark- Life cycle of view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helper method for view controller
-(void)initialSetUp
{
    self.driverTableView.tableHeaderView = self.headerView;
    self.driverTableView.tableFooterView = self.footerView;
    dataSourceArray = [[NSMutableArray alloc] init];
    driverTitleArray = [[NSMutableArray alloc]initWithObjects:@"Driver Name",@"Mobile No",@"Vehicle Name",@"Vehicle No", nil];
    driverValueArray = [[NSMutableArray alloc]initWithObjects:self.driverInfo.strDriverName ,self.driverInfo.strDriverMobileNo,self.driverInfo.strDriverVechileName,self.driverInfo.strDriverVechileNo, nil];
      [self.driverImageView setImageWithURL:[NSURL URLWithString:_driverInfo.strDriverImageInfo] placeholderImage:[UIImage imageNamed:@"user_img3"]];
    
    [self.driverTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FFUserProfileTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FFUserProfileTableCell class])];
    
}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return driverTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFUserProfileTableCell *cell = (FFUserProfileTableCell *)[self.driverTableView dequeueReusableCellWithIdentifier:NSStringFromClass([FFUserProfileTableCell class])];
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:242/256.0f green:242/256.0f  blue:242/256.0f  alpha:1.0f];
    
    cell.cellTextField.userInteractionEnabled = NO;
    cell.sepratedLabel.hidden = YES;
    cell.cellLabel.text = [driverTitleArray objectAtIndex:indexPath.row];
    cell.cellTextField.text = [driverValueArray objectAtIndex:indexPath.row];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}
#pragma mark- UIButton Action Method
- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)contactButtonAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_driverInfo.strDriverMobileNo]]];
}
- (IBAction)cancelButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Cancle Ride" message:@"Are you sure? you want to cancle the ride" andButtonsWithTitle:@[@"YES",@"NO"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if ([buttonTitle isEqualToString:@"YES"]) {
            
            [self callWebApiToCancelRide];
        }
    }];
    
}
- (IBAction)changeDestinationAction:(id)sender {
    
}

-(void)callWebApiToCancelRide{
    
    [[ISServiceHelper sharedInstance] DeleteAPICallWithParameters:nil AndApiType:2 andApiName:kApiRequestCurrent WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [AlertController title:@"" message:[[[result objectForKey:kError] firstObject] valueForKey:@"title"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}


@end
