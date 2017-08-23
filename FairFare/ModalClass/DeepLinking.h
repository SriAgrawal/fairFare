//
//  DeepLinking.h
//  FairFareApp
//
//  Created by Shridhar Agarwal on 23/06/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface DeepLinking : NSObject

+(void)callDeepLinkingOfHailo;
+(void)callDeepLinkingOfUber;
+(void)callDeepLinkingOfLyft:(NSString *)pickMeCoordinate withTakeMeTo:(NSString*)takeMeToCoordinate;
+(void)callDeepLinkingOfWay2Ride;

@end
