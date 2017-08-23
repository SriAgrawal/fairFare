//
//  FFSettingViewController.h
//  FairFare
//
//  Created by Lalit on 04/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dismissToSettingControllerDelegate <NSObject>
-(void)dismissToHomeController:(BOOL)isLogout;
@end

@interface FFSettingViewController : UIViewController
@property(nonatomic,weak) id<dismissToSettingControllerDelegate> delegate;
@end
