//
//  FFDrawPolylineClass.h
//  FairFareApp
//
//  Created by Suresh patel on 28/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface FFDrawPolylineClass : NSObject

+(NSMutableArray *)drawRouteBetweenSource:(NSString*)source andDestination:(NSString*)destination onController:(UIViewController *)controller;

@end
