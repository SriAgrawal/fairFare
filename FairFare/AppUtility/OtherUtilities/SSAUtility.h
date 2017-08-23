//
//  BNUtility.h
//  BuildByNerds
//
//  Created by Ankit Jaiswal on 26/11/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSAUtility : NSObject
+(NSString *)getDayAndTimeFromTimeStamp:(NSTimeInterval)dateInterval;

+ (NSArray *)plistArrayFromFile:(NSString *)fileName;
+ (NSDate *)getDateFromString:(NSString *)dateStr;
void setCornerForTxtField(UITextField *txtField, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
+ (NSDate *)getShortDateFromString:(NSString *)dateStr;
+ (NSString *)getStringFromDate:(NSDate *)date;
+ (NSString *)getStringFromDateWithFormat:(NSDate *)date :(NSString *)format;
+ (NSString *)getTimeFromDate:(NSDate *)date;
+ (NSString *)relativeFormatedDate:(NSDate *)date;
+ (NSLocale *)enUSPosixlocal;
+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
void showAlert(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle);
void showAlertWithtag(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle,int tag);
void setCornerForTxtField(UITextField *txtField, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
void setCornerForImageView(UIImageView *imgView, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
void setCornerForButton(UIButton *btn, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
void setCornerForView(UIView *view, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
void setCornerForLabel(UILabel *label, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
NSAttributedString *setPlaceholderColor(NSString *str, UIColor *color) ;
BOOL isValidEmail(NSString *checkString);
UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);
UIToolbar* toolBarForNumberPadWithTag(id controller, NSString *titleDoneOrNext, NSInteger myTag);

UIColor *getColor(float r,float g,float b,float a);
+ (NSAttributedString *)getMultiAttributedStringWithFontAndColor:(NSString *)completeStr withColor:(UIColor *)completeStrColor withFont:(UIFont *)completeStrFont firstStr:(NSString *)firstStr withColor :(UIColor *)firstStrColor withFont :(UIFont *)firstStrFont secondStr:(NSString *)secondStr withColor:(UIColor *)secondStrColor withFont :(UIFont *)secondStrFont;
+ (NSAttributedString *)getSimpleMultiAttributedString:(NSString *)completeStr firstStr:(NSString *)firstStr withColor :(UIColor *)firstStrColor withFont :(UIFont *)firstStrFont secondStr:(NSString *)secondStr withColor:(UIColor *)secondStrColor withFont :(UIFont *)secondStrFont;
+ (NSAttributedString *)getAttributedStringFor:(NSString *)str attributedStr:(NSString *)attributedStr withColor :(UIColor *)color withFont :(UIFont *)font;
+ (NSAttributedString*)getAttributedString:(NSString*)string seperatedBy:(NSString *)seperationStr firstHalfColor :(UIColor *)color1 firstHalfFont :(UIFont *)font1 secondHalfColor:(UIColor *)color2 secondHalfFont :(UIFont *)font2;
NSString *UTCDateFormateFromDate(NSDate *date);
BOOL matchStringWhileIgnoringCase(NSString *string1, NSString *string2);
+(NSString *)getTimeFromTimeInterval:(NSTimeInterval) timeInterval;
UIBarButtonItem* getBarButtonForController(id controller, NSString *imgStr);
UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr);
+ (NSString*)base64forData:(NSData*)theData;
+(NSString *)convertTime:(NSString *)postDate;
+(void)createShadowOnUIControl:(UIView *)shadow;
UIView* setToolbarViewCustom(id controller);
@end
