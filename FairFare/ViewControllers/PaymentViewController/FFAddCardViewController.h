//
//  FFAddCardViewController.h
//  FairFare
//
//  Created by Ram Chandra on 04/08/17.
//  Copyright © 2017 Ram Chandra. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModalPaymentInfo;

@interface FFAddCardViewController : UIViewController
@property(nonatomic,strong) ModalPaymentInfo* obj;
@property(nonatomic,strong) NSString* str_amount;
@property(nonatomic) BOOL isFromPayment;

@end
