//
//  FFProfileViewController.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 08/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol dismissToProfileControllerDelegate <NSObject>
-(void)dismissToHomeController;
@end


@interface FFProfileViewController : UIViewController

@property(nonatomic,weak) id<dismissToProfileControllerDelegate> delegate;
@property(nonatomic) BOOL isFromSetting;

@end
