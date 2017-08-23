//
//  FFHistoryTableViewCell.h
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *fromAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *toAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;


@end
