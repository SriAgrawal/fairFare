//
//  FFHistoryViewController.h
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class FFHistoryInfo;
@protocol dismissToHomeControllerDelegate <NSObject>
-(void)dismissToHomeController;

-(void)dismissToHomePushToFareController :(FFHistoryInfo *)objHistory;

@end

@interface FFHistoryViewController : UIViewController
@property(nonatomic,weak) id<dismissToHomeControllerDelegate> delegate;
@end
