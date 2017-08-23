//
//  AlertController.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "AlertController.h"


@implementation AlertController


//>>>>>>>>>>>>>>>>>>>>>>>>>> ALERT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (void)title:(NSString *)title onViewController:(UIViewController *)controller {
    [self title:title message:@"" andButtonsWithTitle:@[@"OK"] onViewController:controller dismissedWith:nil];
}

+ (void)title:(NSString *)title message:(NSString *)message onViewController:(UIViewController *)controller {
    [self title:title message:message andButtonsWithTitle:@[@"OK"] onViewController:controller dismissedWith:nil];
}

+ (void)message:(NSString *)message onViewController:(UIViewController *)controller{
    [self title:@"" message:message andButtonsWithTitle:@[@"OK"] onViewController:controller dismissedWith:nil];
}


+ (void)title:(NSString*)title
      message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles onViewController:(UIViewController *)controller
dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock {
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        //NSLog(@"==> Invalid button title!");
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSInteger index = 0; index < buttonTitles.count; index++) {
        
        UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //  AlertActionBLock
            
            if (completionBlock) {
                completionBlock(index, action.title);
            }
        }];
        //alertController.view.tintColor = [UIColor blackColor];
        [alertController addAction:buttonAction];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

//>>>>>>>>>>>>>>>>>>>>>>>>>> ActionSheet >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

+ (void)actionSheet:(NSString*)title
            message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles onViewController:(UIViewController *)controller
      dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock {
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        //NSLog(@"ERROR ==> Invalid button title!");
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Other buttons
    
    for (NSInteger index = 0; index < buttonTitles.count; index++) {
        
        UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //  AlertActionBLock
            
            if (completionBlock) {
                completionBlock(index, action.title);
            }
        }];
        //alertController.view.tintColor = [UIColor blackColor];
        [alertController addAction:buttonAction];
    }
    
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = [((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
    }
    
    // Cancel Button
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        if (completionBlock) {
            completionBlock(buttonTitles.count, @"Cancel");
        }
        
        [rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

@end
