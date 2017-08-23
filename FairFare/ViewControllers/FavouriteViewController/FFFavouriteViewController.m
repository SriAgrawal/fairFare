//
//  FFFavouriteViewController.m
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFFavouriteViewController.h"
#import "FFFavouriteTableViewCell.h"
#import "FFHistoryInfo.h"
#import "Header.h"

static NSString *favouritecellIdentifier = @"FavouriteCellID";

@interface FFFavouriteViewController ()<UITableViewDelegate,UITableViewDataSource,GMSAutocompleteViewControllerDelegate>
{
    FFHistoryInfo *objPlace;
    NSMutableArray *favouriteArray;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation FFFavouriteViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    objPlace = [[FFHistoryInfo alloc] init];
    [self initialMethod];
}

#pragma mark - Custom Method
-(void)initialMethod {
    self.navigationController.navigationBar.hidden = YES;
    // Register TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"FFFavouriteTableViewCell" bundle:nil] forCellReuseIdentifier:favouritecellIdentifier];
    NSArray *tempArray = [NSArray arrayWithObjects:@"Add Home",@"Add Family", @"Add Work",nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"Home",@"3", @"Current location",nil];
    favouriteArray = [NSMutableArray array];
    for (int index = 0; index < tempArray.count; index++) {
        FFHistoryInfo *info = [[FFHistoryInfo alloc]init];
        info.title = [tempArray objectAtIndex:index];
        info.image = [imageArray objectAtIndex:index];
        [favouriteArray addObject:info];
        
    }
    self.tableView.estimatedRowHeight = 80;
    [self callGetSavePlacedApi];
    
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return favouriteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFFavouriteTableViewCell *favCell = (FFFavouriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:favouritecellIdentifier];
    FFHistoryInfo *info = [favouriteArray objectAtIndex:indexPath.row];
    favCell.favoriteTitleLabel.text = info.title;
        if (info.placeAddress.length) {
            favCell.favoriteTitleLabel.textColor = [UIColor blackColor];
            [favCell.favImageView setImage:[UIImage imageNamed:info.image]];
            favCell.favoriteDescriptionLabel.text = info.placeAddress;
            favCell.titleTopConstraint.constant = 8.0;
            favCell.favoriteDescriptionLabel.hidden = NO;
        }else {
            favCell.favoriteTitleLabel.textColor = [UIColor lightGrayColor];
            [favCell.favImageView setImage:[UIImage imageNamed:info.image]];
            //favCell.titleTopConstraint.constant = 18.0;
            favCell.favoriteDescriptionLabel.hidden = YES;
        }
    return  favCell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        objPlace.selectedTitle = @"Home";
    }
    else if (indexPath.row == 1) {
        objPlace.selectedTitle = @"Family";
    }
    else {
        objPlace.selectedTitle = @"Work";
    }

    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    acController.autocompleteFilter.type = 5;
    acController.autocompleteFilter.country = @"USA";
    [self presentViewController:acController animated:YES completion:nil];

}

#pragma mark - GoogleMap Autocompelte Delegate Method
// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    objPlace.placeLat = [NSString stringWithFormat:@"%.03f",place.coordinate.latitude];
    objPlace.placeLong = [NSString stringWithFormat:@"%.03f",place.coordinate.longitude];
    objPlace.placeAddress = place.formattedAddress;

    [self callSavePlacedApi];
}
- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error{
    
    [[AlertView sharedManager] presentAlertWithTitle:@"" message: error.description
                                 andButtonsWithTitle:@[@"Ok"] onController:self
     
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
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

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)callGetSavePlacedApi
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:@"list_savedLocation" forKey:kpAction];
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSMutableArray *arrayList = [result objectForKeyNotNull:@"LocationData" expectedObj:[NSMutableArray array]];
            if([arrayList count]) {
                int indexPathArray = 0;
                for (NSMutableDictionary *dic in arrayList)
                {
                    FFHistoryInfo  *objFav= [[FFHistoryInfo alloc]init];
                    objFav.title = [dic objectForKeyNotNull:@"title" expectedObj:@""];
                    if ([objFav.title isEqualToString:@"Home"]){
                        objFav.placeAddress = [dic objectForKeyNotNull:@"address" expectedObj:@""];
                        objFav.image = @"sel_home";
                        indexPathArray = 0;
                    }
                    else if ([objFav.title isEqualToString:@"Family"]){
                        objFav.placeAddress = [dic objectForKeyNotNull:@"address" expectedObj:@""];
                        objFav.image = @"sel_family";
                        indexPathArray = 1;
                    }
                    else{
                        objFav.placeAddress = [dic objectForKeyNotNull:@"address" expectedObj:@""];
                        objFav.image = @"sel_work";
                        indexPathArray = 2;
                    }
                    objFav.placeLat = [dic objectForKeyNotNull:@"latitude" expectedObj:@""];
                    objFav.placeLong = [dic objectForKeyNotNull:@"longitude" expectedObj:@""];
                    
                    objFav.locationId = [dic objectForKeyNotNull:@"location_id" expectedObj:@""];
                    [favouriteArray replaceObjectAtIndex:indexPathArray withObject:objFav];
                }
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


-(void)callSavePlacedApi
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:@"save_location" forKey:kpAction];
    [valueProfile setValue:objPlace.placeAddress forKey:@"address"];
    [valueProfile setValue:objPlace.placeLat forKey:@"latitude"];
    [valueProfile setValue:objPlace.placeLong forKey:@"longitude"];
    [valueProfile setValue:objPlace.selectedTitle forKey:@"title"];
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
             {
                 [self callGetSavePlacedApi];
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
@end
