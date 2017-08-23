//
//  FFProfileTableViewCell.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 08/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface FFProfileTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *labelCell;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCell;
@property (weak, nonatomic) IBOutlet UIView *viewCell;

@end
