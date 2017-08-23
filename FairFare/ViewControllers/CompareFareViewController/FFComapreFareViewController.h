//
//  FFComapreFareViewController.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 08/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol compareControllerDelegate <NSObject>

-(void)dismissCompareController:(NSString*)strPayment andIsPaid:(BOOL)paid;

@end

@interface FFComapreFareViewController : UIViewController

@property (strong, nonatomic)     ModalHome *modalObj;
@property (weak, nonatomic) id<compareControllerDelegate> compareDelegate;

@end
