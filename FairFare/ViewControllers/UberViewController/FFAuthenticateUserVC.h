//
//  FFAuthenticateUserVC.h
//  FairFareApp
//
//  Created by Suresh patel on 29/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFAuthenticateUserDelegate <NSObject>

-(void)didReceiveAccessToken:(NSString *)accessToken;

@end

@interface FFAuthenticateUserVC : UIViewController

@property (weak, nonatomic) NSString *serviceName;
@property (weak, nonatomic) id <FFAuthenticateUserDelegate> delegate;

@end
