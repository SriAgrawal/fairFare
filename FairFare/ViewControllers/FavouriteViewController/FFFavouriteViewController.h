//
//  FFFavouriteViewController.h
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dismissToFavControllerDelegate <NSObject>
-(void)dismissToHomeController;
@end
@interface FFFavouriteViewController : UIViewController
@property(nonatomic,weak) id<dismissToFavControllerDelegate> delegate;
@end
