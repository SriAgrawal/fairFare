//
//  FFPromoCodeViewController.h
//  FairFare
//
//  Created by Shridhar Agarwal on 09/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dismissToPromoControllerDelegate <NSObject>
-(void)dismissToHomeController;
@end

@interface FFPromoCodeViewController : UIViewController
@property(nonatomic,weak) id<dismissToPromoControllerDelegate> delegate;
@end
