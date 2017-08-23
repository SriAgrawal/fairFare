//
//  AppDelegate.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 03/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "AppDelegate.h"
#import <Stripe/Stripe.h>
#import <Fabric/Fabric.h>
#import <GooglePlaces/GooglePlaces.h>

@interface AppDelegate ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) FFHomeViewController *homeVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [GMSServices provideAPIKey:GOOGLE_API_KEY ];
    
    [GMSPlacesClient provideAPIKey:GOOGLE_API_KEY];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self checkReachability];
    [self getUserLocation];
    [self methodToRegisterDeviceForPushNotification];

    self.navController = [[UINavigationController alloc]initWithRootViewController:[[FFLoginViewController alloc]initWithNibName:@"FFLoginViewController" bundle:nil]];
    [[self window] setRootViewController:self.navController];
    [self.navController.navigationBar setHidden:YES];
    [self.window makeKeyAndVisible];

    //Notification
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [Fabric with:@[[STPAPIClient class]]];

    if (notification) {
        [self application:application didReceiveRemoteNotification:notification];
        
    }
    
    return YES;
}

#pragma mark - Instance method

-(void)methodToRegisterDeviceForPushNotification
{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)])
    {
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


#pragma mark - Delegate Method to Register Device

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString *mytoken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [[NSUserDefaults standardUserDefaults] setValue:[mytoken stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:kpDeviceTokenid ];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kpDeviceTokenid];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //object:nil userInfo:userInfo
    
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Notification!" andMessage:[NSString stringWithFormat:@"%@",userInfo] onController:[APPDELEGATE window].rootViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatus" object:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stopLocation];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self startLocation];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*************** For networking connection check ****************/
-(void)checkReachability {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
            
        });
    };
    [reach startNotifier];
    
}

/*************** For Get Location ****************/

-(void)getUserLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [self startLocation];
}

-(void)startLocation {
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
}

-(void)stopLocation
{
    [locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    self.longitude = [NSString string];
    self.latitude = [NSString string];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    self.userLocation = location.coordinate;
    self.currentLocation = location;
    if (location != nil) {
        self.longitude = [NSString string];
        self.latitude = [NSString string];
        self.latitude = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
        
        
      //  NSLog(@"%@",self.latitude);
     //   NSLog(@"%@",self.longitude);
        
        
               
        
    }
    if(self.statusWalk)
    {
        //call api for updatelocation
    }
    locationManager.delegate = nil;
    //   [self stopLocation];
}

// Set side pannel

-(JASidePanelController *)addRevealView {
    
    self.sidePanelController = nil;
    self.homeVC = [[FFHomeViewController alloc] initWithNibName:@"FFHomeViewController" bundle:nil];
    self.sidePanelController = [[JASidePanelController alloc] init];
    self.sidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.sidePanelController.centerPanel = [[UINavigationController alloc]initWithRootViewController:self.homeVC];
    self.sidePanelController.leftPanel = [[FFSideMenuViewController alloc] initWithNibName:@"FFSideMenuViewController" bundle:nil];
    self.sidePanelController.rightPanel = nil;
    return self.sidePanelController;
}

-(void)requestDictForUpdateLocation {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    AppDelegate *app = APPDELEGATE;
    [paramDict setValue:app.longitude forKey:@"longitude"];
    [paramDict setValue:app.latitude forKey:@"latitude"];
}


@end
