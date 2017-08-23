//
//  FFHomeViewController.h
//  FairFare
//
//  Created by Ankit Kumar Gupta on 03/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@class ModalHome;
@interface FFHomeViewController : UIViewController

@property (assign) BOOL  isFromHistory;

@property (strong, nonatomic)  ModalHome *modalObjNew;

@end
