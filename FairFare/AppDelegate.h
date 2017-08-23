//
//  AppDelegate.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 03/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) JASidePanelController *sidePanelController;

@property(strong,nonatomic) NSString *address;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property (nonatomic, strong) CLLocation * currentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
@property (nonatomic, assign) BOOL isFacebook;
@property (nonatomic, assign) BOOL isReachable;
@property (nonatomic) BOOL statusWalk;

-(JASidePanelController *)addRevealView;
-(void)startLocation;
-(void)stopLocation;

@end

