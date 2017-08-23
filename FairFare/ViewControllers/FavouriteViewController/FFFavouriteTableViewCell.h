//
//  FFFavouriteTableViewCell.h
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFavouriteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *favoriteTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoriteDescriptionLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *favImageView;

@end
