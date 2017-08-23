//
//  SearchPlacesTableViewCell.h
//  FairFareApp
//
//  Created by Pushpraj Chaudhary on 03/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSearchPlacesTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view_OuterView;
@property (strong, nonatomic) IBOutlet UILabel *label_Places;
@property (strong, nonatomic) IBOutlet UILabel *label_Address;

@property (strong, nonatomic) IBOutlet UILabel *label_DynamicAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Icon;
@end
