//
//  FFSearchPlacesViewController.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 04/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@class UserInfo,ModalHome;
@protocol placeDelegate <NSObject>

-(void)getPlaceString:(ModalHome *)obj andIsFor:(BOOL)from;

@end
@interface FFSearchPlacesViewController : UIViewController

@property (strong, nonatomic)  ModalHome  *objDetail;

@property(nonatomic,weak) id<placeDelegate> delegate;
@property (nonatomic) BOOL isForPlace;

@end
