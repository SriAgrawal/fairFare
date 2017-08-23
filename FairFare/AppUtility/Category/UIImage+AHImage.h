//
//  UIImage+AHImage.h
//  AHTO
//
//  Created by Sunil Verma on 12/25/14.
//  Copyright (c) 2014 mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^renderToContext)(CGContextRef, CGRect);

@interface UIImage (AHImage)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize )size;
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

+ (UIImage *)getColoredImage:(UIColor *)color forImage:(UIImage *)image;

// For Color Picker
+ (UIImage *)ah_imageWithSize:(CGSize)size renderer:(renderToContext)renderer;
+ (UIImage *)ah_imageWithSize:(CGSize)size opaque:(BOOL)opaque renderer:(renderToContext)renderer;

@end
