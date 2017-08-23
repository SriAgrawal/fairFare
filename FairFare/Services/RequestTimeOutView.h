//
//  RequestTimeOutView.h
//  Helposity
//
//  Created by Sunil Verma on 02/02/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RequestTimeOutView : UIView
+ (BOOL)isShown;

+ (void)show;
+ (void)showWithMessage:(NSString *)message forTime:(NSInteger)timeInterval;
+ (void)showWithMessage:(NSString *)message forTime:(NSInteger)timeInterval textAlignment:(NSTextAlignment)textAlignment;

+ (void)hide;
@end
