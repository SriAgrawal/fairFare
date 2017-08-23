//
//  AlertController.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertController : NSObject

//>>>>>>>>>>>>>>>>>>>>>>> Alert >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (void)title:(NSString *)title onViewController:(UIViewController *)controller;

+ (void)message:(NSString *)message onViewController:(UIViewController *)controller;

+ (void)title:(NSString *)title message:(NSString *)message onViewController:(UIViewController *)controller;

+ (void)title:(NSString*)title
      message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles onViewController:(UIViewController *)controller
dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock;

//>>>>>>>>>>>>>>>>>>>>>>> ActionSheet >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (void)actionSheet:(NSString*)title
            message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles onViewController:(UIViewController *)controller
      dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock;

@end
