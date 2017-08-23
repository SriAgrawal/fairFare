//
//  FFCompareTableViewCell.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 09/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCompareTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *tagImageView;
@property (strong, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ETATimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceNameLbl;


@end
