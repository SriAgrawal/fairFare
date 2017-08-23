//
//  FFRequestForRideVC.h
//  FairFareApp
//
//  Created by Suresh patel on 28/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol requestRideControllerDelegate <NSObject>

-(void)dismissRequestRideController;

@end

@interface FFRequestForRideVC : UIViewController

@property(nonatomic, assign) BOOL isForBookRide;
@property(nonatomic, strong) NSString * prodict_id;
@property(nonatomic, strong) NSString * paymentId;
@property(nonatomic, strong) NSString * ride_type;
@property(nonatomic, strong) NSString * serviceName;
@property (weak, nonatomic) id<requestRideControllerDelegate> requestDelegate;

@end
