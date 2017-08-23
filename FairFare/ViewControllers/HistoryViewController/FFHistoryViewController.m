//
//  FFHistoryViewController.m
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFHistoryViewController.h"
#import "FFHistoryTableViewCell.h"
#import "FFHistoryInfo.h"
#import "PAPagination.h"
static NSString *historycellIdentifier = @"HistoryCellID";

@interface FFHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *historyArray;
    BOOL isLoading;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage;
@property (strong, nonatomic) PAPagination *pagination;

@end

@implementation FFHistoryViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    [self initialMethod];
}

#pragma mark - Custom Method
-(void)initialMethod {
    // Register TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"FFHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:historycellIdentifier];
    
    historyArray = [NSMutableArray array];
    
    _pagination = [[PAPagination alloc]init];
    self.pagination.pageSize = @"10";
    self.pagination.pageNo = @"1";
    self.tableView.estimatedRowHeight = 171;
    
    [self callGetHistoryAPI :_pagination.pageNo];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFHistoryTableViewCell *historyCell = (FFHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:historycellIdentifier];
    
    FFHistoryInfo *info = [historyArray objectAtIndex:indexPath.row];
    historyCell.fromAddressLabel.text = info.fromAddress;
    historyCell.toAddressLabel.text = info.toAddress;
    historyCell.dateAndTimeLabel.text = info.historyFormattedDateAndTime;
    historyCell.priceLabel.text = [NSString stringWithFormat:@"$%@",info.price];

    return  historyCell;
    
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFHistoryInfo *info = [historyArray objectAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomePushToFareController:)]) {
            [self.delegate dismissToHomePushToFareController:info];
        }
        
    }];
    

}

#pragma mark - UIButtonActrion
- (IBAction)backButtonAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:^{
       if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
            [self.delegate dismissToHomeController];
        }
        
    }];
}

#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 10.0) {
        if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
            isLoading = NO;
            [self callGetHistoryAPI:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
        }
    }
}




-(void)callGetHistoryAPI:(NSString *)pageNo
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:@"get_history" forKey:kpAction];
    [valueProfile setValue:pageNo forKey:@"pageNumber"];
    [valueProfile setValue:@"10" forKey:@"pageSize"];


    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            
            NSDictionary *dict = [result objectForKeyNotNull:@"data" expectedObj:[NSDictionary dictionary]];
            
            _pagination = [PAPagination getPaginationInfoFromDict:[dict objectForKeyNotNull:@"pagination" expectedObj:[NSDictionary dictionary]]];

            
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                NSArray *arrayHistory = [dict objectForKeyNotNull:@"history_list" expectedObj:[NSArray array]];
                if (arrayHistory && [arrayHistory isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict_history in arrayHistory) {
                        // parse data for City List
                        [historyArray addObject:[FFHistoryInfo fetchAllHistory:dict_history]];
                    }
                    isLoading =YES;
                }
            }
            
            if (historyArray.count) {
                [self.labelMessage setHidden:YES];
                [self.tableView setHidden:NO];
            }else{
                [self.labelMessage setHidden:NO];
                [self.tableView setHidden:YES];
                
            }
            [self.tableView reloadData];
            
            
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


#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
