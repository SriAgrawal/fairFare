//
//  PAButton.m
//  PulmonaryApp
//
//  Created by Chandra Shekhar on 4/11/16.
//  Copyright © 2016 Chandra Shekhar. All rights reserved.
//

#import "PAButton.h"

@implementation PAButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self defaultSetup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if(self){
        
        [self defaultSetup];
    }
    return self;
}

- (void)defaultSetup {
    //[self.titleLabel setFont:[AppUtility robotoBoldWithSize:17]];
    self.layer.borderWidth = 0.0f;
    
    self.layer.borderColor = [[UIColor redColor] CGColor];
    
    self.layer.backgroundColor = [[UIColor colorWithRed:229/255.0f green:232/255.0f blue:233/255.0f alpha:1.0f] CGColor];
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
