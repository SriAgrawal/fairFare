//
//  BNTextFiled.m
//  BuildByNerds
//
//  Created by Ankit Jaiswal on 26/11/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "SSATextFiled.h"
#include "Header.h"

@interface SSATextFiled ()

@property (strong, nonatomic) UIImageView *iconImageView;
@end

@implementation SSATextFiled
-(void) awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
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
    
    self.textColor = [UIColor blackColor];
    self.font = AppFont(16);
    
   // setCornerForTxtField(self, [UIColor lightGrayColor], 1.0f, 5.0f);
    [self setupPlaceHolder];
   // [self addPadding];
}

- (void)setupPlaceHolder {
    
    if (self.placeholder.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName :AppFont(14),NSForegroundColorAttributeName:[UIColor whiteColor]}];
      //  RGBCOLOR(114, 114, 114, 1)
    }
}

- (void)setPlaceHolderText:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :AppFont(14),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}
- (void)setPlaceHolderTextBlack:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :AppFont(14),NSForegroundColorAttributeName:RGBCOLOR(37, 35, 35, 1)}];
    }
}
- (void)setPlaceHolderTextLightGray:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :AppFont(14),NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    }
}

- (void)addPaddingWithValue:(CGFloat )value {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, value, self.frame.size.height)];
    [self setLeftView:paddingView];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self addplaceHolderImageInsideView:paddingView];
}

//- (void)addPadding {
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, self.frame.size.height)];
//    [self setLeftView:paddingView];
//    
//    [self setLeftViewMode:UITextFieldViewModeAlways];
//
//}

- (void)addplaceHolderImageInsideView:(UIView *)view {
    UIImageView *placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
    placeHolderImageView.contentMode = UIViewContentModeScaleAspectFit;
    placeHolderImageView.center = view.center;
    placeHolderImageView.tag = 999;
    //placeHolderImageView.backgroundColor = [UIColor redColor];
    self.iconImageView = placeHolderImageView;
    [view addSubview:placeHolderImageView];
    
}
- (void)setPaddingIcon:(UIImage *)iconImage {
    [self.iconImageView setImage:iconImage];
}
- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}
@end
