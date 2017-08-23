//
//  BNUtility.m
//  BuildByNerds
//
//  Created by Ankit Jaiswal on 26/11/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "SSAUtility.h"
#import "Header.h"

@implementation SSAUtility

// use to get data from main bundle plist
+ (NSArray *)plistArrayFromFile:(NSString *)fileName {
    NSMutableArray *list = [[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]] mutableCopy];
    
    return list;
}

+ (NSDate *)getDateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    
    return [dateFormatter dateFromString: dateStr];
    
}

+ (NSDate *)getShortDateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter dateFromString: dateStr];
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    
    return [dateFormatter stringFromDate: date];
}
+ (NSString *)getStringFromDateWithFormat:(NSDate *)date :(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate: date];
}
+ (NSString *)getTimeFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[SSAUtility enUSPosixlocal]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    return [dateFormatter stringFromDate:date];
    
}

+ (NSString *)relativeFormatedDate:(NSDate *)date {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterFullStyle;
    df.doesRelativeDateFormatting = YES;
    
    return [df stringFromDate:date];
    
}
+ (NSLocale *)enUSPosixlocal {
    return  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
}

+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Showing Alert with delegate <<<<<<<<<<<<<<<<<<<<<<<<*/

//void showAlert(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle) {
//    
//    [[AlertView sharedManager] presentAlertWithTitle:@"" message:message
//                                 andButtonsWithTitle:@[@"ok"] onController:nil
//     
//                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                                       }];
//    
//}

//void showAlertWithtag(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle,int tag) {
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:buttonTitle, nil];
//    alertView.tag = tag;
//    [alertView show];
//    alertView = nil;
//    
//}

// Left bar Back button on navigation bar
UIBarButtonItem* getBarButtonForController(id controller, NSString *imgStr) {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateSelected];
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    [button addTarget:controller action: @selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}
//Method for Setting rightbar button for navigationbar
UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr) {
    UIImage * buttonImage = [UIImage imageNamed:imgStr];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height);
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateSelected];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    [backButton addTarget:controller action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UITextField <<<<<<<<<<<<<<<<<<<<<<<<*/

void setCornerForTxtField(UITextField *txtField, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius) {
    txtField.layer.cornerRadius =  cornerRadius;
    txtField.layer.borderColor = [borderColor CGColor];
    txtField.layer.borderWidth = borderWidth;
    txtField.clipsToBounds = YES;
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UIImageView <<<<<<<<<<<<<<<<<<<<<<<<*/

void setCornerForImageView(UIImageView *imgView, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius) {
    imgView.layer.cornerRadius =  cornerRadius;
    imgView.layer.borderColor = [borderColor CGColor];
    imgView.layer.borderWidth = borderWidth;
    imgView.clipsToBounds = YES;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UIButton <<<<<<<<<<<<<<<<<<<<<<<<*/

void setCornerForButton(UIButton *btn, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius) {
    
    btn.layer.cornerRadius =  cornerRadius;
    btn.layer.borderColor = [borderColor CGColor];
    btn.layer.borderWidth = borderWidth;
    btn.clipsToBounds = YES;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UIView <<<<<<<<<<<<<<<<<<<<<<<<*/

void setCornerForView(UIView *view, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius) {
    
    view.layer.cornerRadius =  cornerRadius;
    view.layer.borderColor = [borderColor CGColor];
    view.layer.borderWidth = borderWidth;
    view.clipsToBounds = YES;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UILabel <<<<<<<<<<<<<<<<<<<<<<<<*/

void setCornerForLabel(UILabel *label, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius) {
    
    label.layer.cornerRadius =  cornerRadius;
    label.layer.borderColor = [borderColor CGColor];
    label.layer.borderWidth = borderWidth;
    label.clipsToBounds = YES;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Set placeholder <<<<<<<<<<<<<<<<<<<<<<<<*/

NSAttributedString *setPlaceholderColor(NSString *str, UIColor *color) {
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:str];
    
    [attString addAttribute: NSForegroundColorAttributeName
                      value: color
                      range: NSMakeRange(0,str.length)];
    
    return attString;
}


+(void)createShadowOnUIControl:(UIView *)shadow {
    
    shadow.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    [shadow.layer setShadowOffset:CGSizeMake(2, 2)];
    shadow.layer.masksToBounds = NO;
    shadow.layer.shadowOffset = CGSizeMake(0, 2);
    shadow.layer.shadowRadius = 2;
    shadow.layer.shadowOpacity = 0.6;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Validate Email <<<<<<<<<<<<<<<<<<<<<<<<*/
BOOL isValidEmail(NSString *checkString) {
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Tool Bar <<<<<<<<<<<<<<<<<<<<<<<<*/

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    //NSString *doneOrNext;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad)],
                           
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Tool Bar With Tag <<<<<<<<<<<<<<<<<<<<<<<<*/

UIToolbar* toolBarForNumberPadWithTag(id controller, NSString *titleDoneOrNext, NSInteger myTag){
    //NSString *doneOrNext;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    
    numberToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *objBtn = [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad:)];
    objBtn.tag = myTag;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], objBtn
                           ,
                           
                           nil];
    
    [numberToolbar sizeToFit];
    return numberToolbar;
}


UIView* setToolbarViewCustom(id controller){
    if ([controller isKindOfClass:[FFVirfyViewController class]]) {
     
        UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
        [numberToolbar setBackgroundColor:[UIColor clearColor]];
        UIButton* leftBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 50)];
        [leftBarButton setTitle:@"Resend" forState:UIControlStateNormal];
        [leftBarButton.titleLabel setFont:AppFont(15)];
        [leftBarButton addTarget:controller action:@selector(resendCodeAction) forControlEvents:UIControlEventTouchUpInside];
        //[rightBarButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        
        UIButton* rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-60, 0, 50, 50)];
        [rightBarButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [rightBarButton addTarget:controller action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
        [numberToolbar addSubview:leftBarButton];
        [numberToolbar addSubview:rightBarButton];
        return numberToolbar;
        
    }
    UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    [numberToolbar setBackgroundColor:[UIColor clearColor]];
    UIButton* rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-60, 0, 50, 50)];
    [rightBarButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [rightBarButton addTarget:controller action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [numberToolbar addSubview:rightBarButton];
    return numberToolbar;
}


- (void)doneWithNumberPad {
    
    
}

- (void)resendCodeAction {
    
    
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Getting color <<<<<<<<<<<<<<<<<<<<<<<<*/

UIColor *getColor(float r,float g,float b,float a) {
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Getting Attributed String <<<<<<<<<<<<<<<<<<<<<<<<*/

+ (NSAttributedString *)getMultiAttributedStringWithFontAndColor:(NSString *)completeStr withColor:(UIColor *)completeStrColor withFont:(UIFont *)completeStrFont firstStr:(NSString *)firstStr withColor :(UIColor *)firstStrColor withFont :(UIFont *)firstStrFont secondStr:(NSString *)secondStr withColor:(UIColor *)secondStrColor withFont :(UIFont *)secondStrFont {
    
    NSString *effectedStr1 = [NSString stringWithFormat:@"(%@)",firstStr];
    NSString *effectedStr2 = [NSString stringWithFormat:@"(%@)",secondStr ];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //replacing "AND" to "and" and coloring white
    //NSString *text = [initialStr stringByReplacingOccurrencesOfString:@"AND" withString:@"and"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:completeStr];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:completeStrColor range:NSMakeRange(0,completeStr.length)];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:effectedStr1 options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,completeStr.length);
    [regex enumerateMatchesInString:completeStr options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:firstStrFont range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:firstStrColor range:subStringRange];
    }];
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:effectedStr2 options:kNilOptions error:nil];
    NSRange range1 = NSMakeRange(0,completeStr.length);
    [regex1 enumerateMatchesInString:completeStr options:kNilOptions range:range1 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:secondStrFont range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:secondStrColor range:subStringRange];
    }];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    return mutableAttributedString;
}
+ (NSAttributedString *)getSimpleMultiAttributedString:(NSString *)completeStr firstStr:(NSString *)firstStr withColor :(UIColor *)firstStrColor withFont :(UIFont *)firstStrFont secondStr:(NSString *)secondStr withColor:(UIColor *)secondStrColor withFont :(UIFont *)secondStrFont {
    
    NSString *effectedStr1 = [NSString stringWithFormat:@"(%@)",firstStr];
    NSString *effectedStr2 = [NSString stringWithFormat:@"(%@)",secondStr ];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:completeStr];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:effectedStr1 options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,completeStr.length);
    [regex enumerateMatchesInString:completeStr options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:firstStrFont range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:firstStrColor range:subStringRange];
    }];
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:effectedStr2 options:kNilOptions error:nil];
    NSRange range1 = NSMakeRange(0,completeStr.length);
    [regex1 enumerateMatchesInString:completeStr options:kNilOptions range:range1 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:secondStrFont range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:secondStrColor range:subStringRange];
    }];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    return mutableAttributedString;
}
+ (NSAttributedString *)getAttributedStringFor:(NSString *)str attributedStr:(NSString *)attributedStr withColor :(UIColor *)color withFont :(UIFont *)font {
    
    NSString *effectedStr1 = [NSString stringWithFormat:@"(%@)",attributedStr];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:effectedStr1 options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,str.length);
    [regex enumerateMatchesInString:str options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:font range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:subStringRange];
    }];
    
    return mutableAttributedString;
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Getting Attributed String Based on Seperation <<<<<<<<<<<<<<<<<<<<<<<<*/
+ (NSAttributedString*)getAttributedString:(NSString*)string seperatedBy:(NSString *)seperationStr firstHalfColor :(UIColor *)color1 firstHalfFont :(UIFont *)font1 secondHalfColor:(UIColor *)color2 secondHalfFont :(UIFont *)font2 {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    if (!seperationStr.length || ![string containsString:seperationStr]) {
        return attrString;
    }
    
    [attrString beginEditing];
    
    // validating that string contails white space or not
    //NSRange whiteSpaceRange = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    //if (whiteSpaceRange.location != NSNotFound) {
    NSArray *components = [string componentsSeparatedByString:seperationStr];
    NSRange whiteRange = [string rangeOfString:[components objectAtIndex:0]];
    NSRange darkRange = [string rangeOfString:[components objectAtIndex:1]];
    
    [attrString addAttribute: NSForegroundColorAttributeName
                       value:color1
                       range:whiteRange];
    [attrString addAttribute:NSFontAttributeName
                       value:font1
                       range:whiteRange];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color2
                       range:darkRange];
    
    [attrString addAttribute:NSFontAttributeName
                       value:font2
                       range:darkRange];
    
    
    [attrString endEditing];
    
    return attrString;
    //}
    
    //return attrString;
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Getting UTC Date Formatted String <<<<<<<<<<<<<<<<<<<<<<<<*/

NSString *UTCDateFormateFromDate(NSDate *date) {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"];
    
    return [dateFormat stringFromDate:date];
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Matching Two Strings Ignoring Case <<<<<<<<<<<<<<<<<<<<<<<<*/

BOOL matchStringWhileIgnoringCase(NSString *string1, NSString *string2) {
    if ([string1 caseInsensitiveCompare:string2] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> TextField Masking Method <<<<<<<<<<<<<<<<<<<<<<<<*/

NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter) {
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done) {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0') {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar)) {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSMutableString stringWithUTF8String:outputString];
}
#pragma mark -

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> to hide warnings -- Button Action Methods <<<<<<<<<<<<<<<<<<<<<<<<*/


+(NSString *)getDayAndTimeFromTimeStamp:(NSTimeInterval)dateInterval {
    
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date] toDate:eventDate options:0];
    
    
    NSString *dayAndTime = [NSString stringWithFormat:@"%ld,%ld,%ld,%ld",(long)[components month],(long)[components day],(long)[components hour],(long)[components minute]];
    
    return dayAndTime;
}

+(NSString *)getTimeFromTimeInterval:(NSTimeInterval) timeInterval
{
    
    double minutes = fmod(trunc(timeInterval / (60.0)), 60.0);
    double hours = trunc(timeInterval / (3600.0));
    return [NSString stringWithFormat:@"%.0f : %.0f",hours,minutes];
}
-(void)backButtonAction:(id)sender{}
- (void)rightButtonAction:(id)sender {}

//for base64 from Nsdata

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(NSString *)convertTime:(NSString *)postDate {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:postDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&date
                 interval:NULL forDate:date];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&now
                 interval:NULL forDate:now];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitSecond
                                               fromDate:date toDate:now options:0];
    if([difference second] < 60)
    {
        return [NSString stringWithFormat:@"%ld second ago",(long)[difference second]];
    }
    else
        if(([difference second] > 60) && ([difference second] < 3600))
    {
        NSDateComponents *difference = [calendar components:NSCalendarUnitMinute
                                                   fromDate:date toDate:now options:0];
        return [NSString stringWithFormat:@"%ld minute ago",(long)[difference minute]];
    }
    else
        if(([difference second] > 3600) && ([difference second] < 3600*24))
    {
                  NSDateComponents *difference = [calendar components:NSCalendarUnitHour
                                                                   fromDate:date toDate:now options:0];
        return [NSString stringWithFormat:@"%ld hour ago",(long)[difference hour]];

    }
    else
    {
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:date toDate:now options:0];
        return [NSString stringWithFormat:@"%ld day ago",(long)[difference day]];
 
    }
}

@end
