//
//  Header.h
//  BuildByNerds
//
//  Created by Priyanka Singh on 25/11/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#ifndef BuildByNerds_Header_h
#define BuildByNerds_Header_h

#define TRIM_SPACE(str)         [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)

#define KTextField(tag)         (UITextField*)[self.view viewWithTag:tag]
#define KButton(tag)            (UIButton *)[self.view viewWithTag:tag]
#define WIN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define WIN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#define APPDELEGATE             (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define ButtonTag(tag)         (UIButton *)[self.view viewWithTag:tag]

#define NSUSERDEFAULT           [NSUserDefaults standardUserDefaults]

#define IS_OS_8_OR_LATER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define DEGREES_TO_RADIANS(degrees) (M_PI * (degrees) / 180.0)

//log label
#define LOG_LEVEL           1

#define ATLog(frmt, ...)    if(LOG_LEVEL) NSLog((@"%s" frmt), __PRETTY_FUNCTION__, ## __VA_ARGS__);

#define RGBCOLOR(r,g,b,a)               [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define BlackColor                   [UIColor blackColor]
#define ClearColor                   [UIColor clearColor]
#define WhiteColor                      [UIColor whiteColor]

#define AppFont(X) [UIFont fontWithName:@"SFUIDisplay-Regular" size:X]
#define ACCEPTABLE_CHARACTER @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@."
#define GOOGLE_API_KEY   @"AIzaSyAkM1kih1RDREjz-GqUD76YiJIg7u8X5fo"
//#define GOOGLE_API_KEY   @"AIzaSyBt7Md7RAC98G4Sh-o0Tt2zkfHSC3anRpI"
#define GOOGLE_GEOLOCATION_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define NSUSERDEFAULT        [NSUserDefaults standardUserDefaults]


//#define CLIENT_ID           @"gdSzxhaqFwjXly338goebrVCh_A7ND8b"
//#define CLIENT_SECRET       @"HqrriOPDjaA9GGga5tXWe1V-Zu_5-zQtRuWbE7YL"
//#define SERVER_TOKEN        @"uv8_GcC6nt-Vdy0FNZPZTYrQwVZsW2kIpmzoK68w"
//#define REDIRECT_URL        @"http://www.mobiloitte.com"

//
//#define CLIENT_ID           @"qD1K72BWLEcBQnuERE3k6-WqSH0WbWDs"
//#define CLIENT_SECRET       @"DsqFxP_AxsFcBQoaC_cjeshJbojNjpF5lsMIpatU"
//#define SERVER_TOKEN        @"d_KAOZ4ck5OuSFPXYQgNnDlCWaCDqR_PfdkI-AaE"
//#define REDIRECT_URL        @"https://www.mobiloitte.com"


//CLient credentials
#define CLIENT_ID           @"cO2nXPYj_7QV3HI-ro5muT_9cZ0Ho0Y9"
#define CLIENT_SECRET       @"wWg0jpNdlt3rIoZYeIuNXHh_AfhSXWQuFxkl3b5n"
#define SERVER_TOKEN        @"hp639lLDwDzztp3mSzYqg3GMGMMBaeWu4s6vX25X"
#define REDIRECT_URL        @"https://www.mobiloitte.com"



//Vinayb
//#define CLIENT_ID           @"aqtc4A9ZN1OYYZ-oNyBTJqesNHY93uMy"
//#define CLIENT_SECRET       @"QPufbgLGzJDHByF8ne7bbMSBcs-7qHaZREVEcfFW"
//#define SERVER_TOKEN        @"Jq1jTXznEj8ayu70_JE1pHTt46ehtzCPbc2OTDxI"
//#define REDIRECT_URL        @"https://www.mobiloitte.com"

//New Account
//#define CLIENT_ID           @"0Pdn7ngvA5PPBupQJE78lcFOd62P8oaA"
//#define CLIENT_SECRET       @"S6ZaJiZBUyL8vtuLum0Hx3Ur-6aNsZi3-Orrmw0b"
//#define SERVER_TOKEN        @"kNeL7mSavB1XikdO_zYT4M4eum7Vx3HHgob0tGjr"
//#define REDIRECT_URL        @"https://www.mobiloitte.com"K

//Ankit Account
//#define CLIENT_ID           @"HeoHJpEmmy3aDnY7gpGYToJ6QeljpWxD"
//#define CLIENT_SECRET       @"tDSMnvr1ewphguxsjwA8Ju4XBszg01zBbPs-oG56"
//#define SERVER_TOKEN        @"3KVYAIUSGNFXGVnwfp8Vhv5V55CVYQnhvO0uTcqO"
//#define REDIRECT_URL        @"https://www.mobiloitte.com"

//LYFT CLient credentials
#define LYFTCLIENT_ID           @"0UMnmmRqa8m_"
#define LYFTCLIENT_SECRET       @"EXJJki0hJakSFGeSKAYFgIw5AtyTwqR8"
//#define LYFTSERVER_TOKEN        @"hp639lLDwDzztp3mSzYqg3GMGMMBaeWu4s6vX25X"
#define REDIRECT_URL            @"https://www.mobiloitte.com"

//#undef NSLocalizedString
//#define NSLocalizedString(key,_comment) [[LocalizationHandlerUtil singleton] localizedString:key  comment:_comment]

# define KAlert_Empty_CardNumber     @"*Please enter your card number.";
# define KAlert_MAX_CardNumber       @"*Card number must be 16 digits long.";
# define KAlert_Empty_ExpiryDate     @"*Please select the expiry date of your card.";
# define KAlert_Empty_CVV            @"*Please enter your CVV number.";
# define KAlert_MAX_CVV              @"*CVV number must be 4 digits long.";
# define KAlert_BLANKCONTACT         @"*Please enter mobile number.";
# define KAlert_MIN_CONTACT          @"*Pleae enter at least 10 digits.";
# define KAlert_BLANKCODE            @"*Please enter code.";
# define KAlert_BLANKFIRSTCODE       @"*Please enter first digit of code.";
# define KAlert_BLANKSECONDCODE      @"*Please enter second digit of code.";
# define KAlert_BLANKTHIRDCODE       @"*Please enter third digit of code.";
# define KAlert_BLANKFOURTHCODE      @"*Please enter fourth digit of code.";
# define KAlert_BLANKFIVECODE        @"*Please enter fifth digit of code.";
# define KAlert_BLANKSIXCODE         @"*Please enter sixth digit of code.";


#pragma mark - Frameworks

//#import "LocalizationHandlerUtil.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GGLCore/GGLCore.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <GooglePlaces/GooglePlaces.h>

#pragma mark - Web Services Helper Classes
#import "NSDictionary+NullChecker.h"

#pragma mark - StoryBoardInfo

#pragma mark - Local DB Classes


#pragma mark - Sub Classes
#import "SSAUIPlaceholderTextView.h"
#import "IndexPathButton.h"
#import "PATextField.h"
#import "PAButton.h"
#import "WCSContactPicker/WCSContactPicker.h"
#import "WCSContactPicker/Contact.h"
#import "BDVCountryNameAndCode.h"

#pragma mark - Category Classes
#import "NSDictionary+NullChecker.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "Reachability.h"
#import "UIView+Addition.h"
#import "NSString+Validator.h"

#pragma mark - External Class
#import "TLTagsControl.h"
#import "JASidePanelController.h"
//#import "MVPlaceSearchTextField.h"

#pragma mark - Utility Files

#import "AppDelegate.h"
#include "SSAUtility.h"
#include "SSAValidatesField.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "FFDrawPolylineClass.h"
#import "AlertController.h"

#pragma mark - Service Helper
#import "ISConstants.h"
#import "ISServiceHelper.h"

#pragma mark - ModalClass
#import "UserInfo.h"
#import "DeepLinking.h"

#pragma mark - View Controllers

#import "FFLoginViewController.h"
//#import "FFForgotPasswordVC.h"
//#import "FFConfirmationVC.h"
//#import "FFSignUpVC.h"
//#import "FFPrivacyPolicyVC.h"
//#import "FFMenuListVC.h"
#import "FFHomeViewController.h"
//#import "FFRiderListViewController.h"
//#import "FFUserProfileVC.h"
//#import "FFChangePasswordVCViewController.h"
//#import "FFFeedBackVC.h"
//#import "FFCompareVC.h"
//#import "FFInviteFriendsVC.h"
//#import "FFSavedPlacedVC.h"
#import "FFSearchPlacesViewController.h"
#import "FFPaymentMethodViewController.h"
#import "FFAddCardViewController.h"
#import "FFSideMenuViewController.h"
#import "FFHistoryInfo.h"
#import "FFHistoryViewController.h"
#import "FFFavouriteViewController.h"
#import "FFSettingTableCell.h"
#import "FFSettingViewController.h"
#import "FFPrivacyPolicyVC.h"
#import "FFVirfyViewController.h"
#import "FFPromoCodeViewController.h"
#import "FFProfileViewController.h"
#import "FFAuthenticateUserVC.h"
#import "FFRequestForRideVC.h"
#import "FFDriverViewController.h"
#import "FFComapreFareViewController.h"


//Below controllers have their "StoryBoardID" prefix by "ID" to their "Name"
// e.g. controller "AHSignInVC" has StoryBoardID as "AHSignInVCID"

#pragma mark -Custom Class

#import "DatePickerSheetView.h"
#import "ActionSheet.h"
#import "AlertView.h"
#import "MZSelectableLabel.h"
#import "OptionsPickerSheetView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

#import "SSATextFiled.h"
#import "SSAUnderLineButton.h"
#import "SSAUIButtonBorder.h"

#pragma mark - UITableViewCells
//#import "FFLoginTableCell.h"
//#import "FFSignUpTableCell.h"
//#import "FFMenuTableCell.h"
//#import "FFRiderListTableCell.h"
//#import "FFUserProfileTableCell.h"
//#import "FFCompareTableViewCell.h"
//#import "FFSavePlaceTableCell.h"
//#import "FFUserProfileHeaderTableCell.h"
//#import "FFSavedPlacesTableCell.h"
#import "FFSearchPlacesTableCell.h"
#import "FFPaymentTableViewCell.h"
#import "FFUserProfileTableCell.h"
//#import "FFReportTabelCell.h"


#pragma mark - UICollectionHeaderView

#pragma mark - UICollectionViewCells


#endif
