//
//  FFUserProfileTableCell.h
//  FairFareApp
//
//  Created by Shridhar Agarwal on 30/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface FFUserProfileTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) IBOutlet UITextField *cellTextField;
@property (strong, nonatomic) IBOutlet UILabel *sepratedLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@end
