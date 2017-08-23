//
//  FFPaymentMethodViewController.h
//  FairFare
//
//  Created by Sarvada Chauhan on 8/4/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol dismissToPaymentDelegate <NSObject>
-(void)dismissToHomeController;
@end

@interface FFPaymentMethodViewController : UIViewController
@property(nonatomic,weak) id<dismissToPaymentDelegate> delegate;
@property(nonatomic,strong) NSString* strAmount;
@property(nonatomic) BOOL isFromPayment;
@end
