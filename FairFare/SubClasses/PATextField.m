//
//  PATextField.m
//  PulmonaryApp
//
//  Created by Chandra Shekhar on 4/11/16.
//  Copyright © 2016 Chandra Shekhar. All rights reserved.
//

#import "PATextField.h"
#import "Header.h"


#define RGBCOLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

@interface PATextField ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIView *paddingView;

@end

@implementation PATextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
  
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
    
    self.textColor = [UIColor whiteColor];
    self.font = AppFont(14);
    [self setBackgroundColor:[UIColor clearColor]];
   // [self setFont:[AppUtility robotoRegularWithSize:15]];
    
    [self setupPlaceHolder];
}

- (void)placeHolderWith:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
       UIColor *color = [UIColor whiteColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    }
}

- (void)setupPlaceHolder {
    if (self.placeholder.length) {//for avoiding nil placehoder
        UIColor *color = [UIColor whiteColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

- (void)addPaddingWithValue:(CGFloat )value {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, value, self.frame.size.height)];
    [self setLeftView:paddingView];
    paddingView.tag = 998;
    self.paddingView = paddingView;
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)addplaceHolderImageInsideView:(UIView *)view placeHolderImage:(UIImage *)image {
    UIImageView *placeHolderImageView = [view viewWithTag:999];
    if (!placeHolderImageView) {
        placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        placeHolderImageView.center = view.center;
        placeHolderImageView.tag = 999;
        [view addSubview:placeHolderImageView];
    }
    [placeHolderImageView setImage:image];
    self.iconImageView = placeHolderImageView;
}
- (void)setPaddingIcon:(UIImage *)iconImage {
    
    [self addplaceHolderImageInsideView:self.paddingView placeHolderImage:iconImage];
}
- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}

- (void)setPlaceholderImage:(UIImage *)iconImage {
    if (iconImage) {
        [self setPaddingIcon:iconImage];
    }
}

/***************** Change the border color of uitextfield according to its state  ****************/

- (void)active {
    [self setErrorStatus:activeType];
}
- (void)inactive {
    [self setErrorStatus:defaultType];
}
- (void)error {
    [self setErrorStatus:errortype];
}
- (void)checkForError {
    if (![TRIM_SPACE(self.text) length]) {
        [self setErrorStatus:errortype];
    } else {
        [self setErrorStatus:defaultType];
    }
    
}

- (void)setErrorStatus:(Type)status {
    switch (status) {
        case defaultType:
            self.layer.borderColor = [UIColor grayColor].CGColor;
            break;
        case activeType:
            self.layer.borderColor = [UIColor greenColor].CGColor;
            break;
        case errortype:
            self.layer.borderColor = [UIColor redColor].CGColor;
            break;
            
        default:
            break;
    }
}


@end
