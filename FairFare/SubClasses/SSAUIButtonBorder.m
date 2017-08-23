//
//  RDUIButtonBorder.m
//  RunToDonateApp
//
//  Created by Ankit on 12/2/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "SSAUIButtonBorder.h"

@implementation SSAUIButtonBorder


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.layer.borderColor = [UIColor colorWithRed:218/255.0f green:82/255.0f blue:80/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.layer.backgroundColor = [UIColor colorWithRed:218/255.0f green:82/255.0f blue:80/255.0f alpha:1.0f].CGColor;
    
}


@end
