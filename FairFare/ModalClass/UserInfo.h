//
//  UserInfo.h
//  FairFareApp
//
//  Created by Shridhar Agarwal on 26/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface UserInfo : NSObject

@property(nonatomic,strong) NSString *strName;
@property(nonatomic,strong) NSString *strEmail;
@property(nonatomic,strong) NSString *strContact;
@property(nonatomic,strong) NSString *strImage;
@property(nonatomic,strong) NSString *strImageData;

@property(nonatomic,strong) NSString *strAddress;
@property(nonatomic,strong) NSString *strLocation;
@property(nonatomic,strong) NSString *strFullAddress;
@property(nonatomic,strong) NSString *strCountryCode;
@property(nonatomic,strong) NSString *firstName;
@property(nonatomic,strong) NSString *lastName;

@property(nonatomic,strong) NSString *strTitle;
@property(nonatomic,strong) NSString *strLatitude;
@property(nonatomic,strong) NSString *strLongitude;
@property(nonatomic,strong) NSString *strLocationID;
@property(nonatomic,strong) NSString *strWorkAddress;
@property(nonatomic,strong) NSString *strHomeAddress;

@property (nonatomic,strong) NSString* cardNumber;
@property (nonatomic,strong) NSString* expirydate;
@property (nonatomic,strong) NSString* cvvNumber;

@end


#pragma mark - Modal Invoice

@interface ModalInvoice : NSObject

@property(nonatomic,strong) NSString *strRideName;
@property(nonatomic,strong) NSString *strDriverName;
@property(nonatomic,strong) NSString *strTotalDistance;
@property(nonatomic,strong) NSString *strTotalDuration;
@property(nonatomic,strong) NSString *strTotalFare;
@property(nonatomic,strong) NSString *strSubTotal;
@property(nonatomic,strong) NSString *strTotalCharge;
+(ModalInvoice*)getInvoiceOfDetails:(NSDictionary*)dict;

@end

#pragma mark - Modal Driver Info

@interface ModalDriverInfo : NSObject

@property(nonatomic,strong) NSString *strDriverName;
@property(nonatomic,strong) NSString *strDriverImageInfo;
@property(nonatomic,strong) NSString *strDriverMobileNo;
@property(nonatomic,strong) NSString *strDriverVechileName;
@property(nonatomic,strong) NSString *strDriverVechileNo;

+(ModalDriverInfo*)getDriverDetails:(NSDictionary*)dict;

@end

#pragma mark - Modal Payment Method

@interface ModalPaymentInfo : NSObject

@property(nonatomic,strong) NSString *strPaymentId;
@property(nonatomic,strong) NSString *strPaymentMethodName;
@property(nonatomic,strong) NSString *strPaymentCardNumber;
@property(nonatomic,strong) NSString *strCardate;
@property(nonatomic,strong) NSString *strOriginalCardNumber;
@property(nonatomic,strong) NSString *strCvv;


+(NSMutableArray*)getPaymentMethodDetails:(NSMutableArray*)payArray;

@end


#pragma mark - Modal logIn

@interface ModalLoginIn : NSObject

@property(nonatomic,strong) NSString *strEmail;
@property(nonatomic,strong) NSString *strPassword;

@end

#pragma mark - Modal SignUp

@interface ModalSignUp : NSObject

@property(nonatomic,strong) NSString *strFirstName;
@property(nonatomic,strong) NSString *strLastName;
@property(nonatomic,strong) NSString *strEmail;
@property(nonatomic,strong) NSString *strContact;
@property(nonatomic,strong) NSString *strPassword;
@property(nonatomic,strong) NSString *strConfirmPassword;
@property(nonatomic,strong) NSString *strImage;
@property(nonatomic,assign) bool isAccept;

@end


#pragma mark - Modal Home

@interface ModalHome : NSObject

@property(nonatomic,strong) NSString *strPickLat;
@property(nonatomic,strong) NSString *strPickLong;
@property(nonatomic,strong) NSString *strTakeLat;
@property(nonatomic,strong) NSString *strTakeLong;
@property(nonatomic,strong) NSString *strPickAddress;
@property(nonatomic,strong) NSString *strTakeAddress;

@property(nonatomic, assign) CLLocationCoordinate2D sourceCoordinate;
@property(nonatomic, assign) CLLocationCoordinate2D destinationCoordinate;


@property(nonatomic,strong) NSString *strAddress;
@property(nonatomic,strong) NSString *strLocation;
@property(nonatomic,strong) NSString *strFullAddress;

@property(nonatomic,strong) NSString *strLatitude;
@property(nonatomic,strong) NSString *strLongitude;
@property(nonatomic,strong) NSMutableArray *favArray;

@end

#pragma mark - Modal Confirmation Code
@interface ModalConfimationCode : NSObject
@property(nonatomic,strong) NSString *strConfirmationCode;
@end

#pragma mark - Modal FeedBack
@interface ModalFeedback : NSObject
@property(nonatomic,strong) NSString *strSubject;
@property(nonatomic,strong) NSString *strDescription;
@end

#pragma mark - Modal Change Passwords

@interface ModalChangePassword : NSObject
@property(nonatomic,strong) NSString *strOldPassword;
@property(nonatomic,strong) NSString *strNewPassword;
@property(nonatomic,strong) NSString *strConfirmPassword;
@end

#pragma mark - Modal RiderList

@interface ModalRiderList : NSObject

@property(nonatomic,strong) NSString *strCompanyLogo;
@property(nonatomic,strong) NSString *strCompanyName;
@property(nonatomic,strong) NSString *strServiceName;
@property(nonatomic,strong) NSString *strEstimateTime;
@property(nonatomic,strong) NSString *strCompanyFare;
@property(nonatomic,strong) NSString *strProductId;
@property(nonatomic,strong) NSString *strDistance;
@property(nonatomic,strong) NSString *strRideType;
@end

#pragma mark - Modal MyTrips

@interface ModalTrips : NSObject

@property(nonatomic,strong) NSString *strCompanyLogo;
@property(nonatomic,strong) NSString *strCompanyName;
@property(nonatomic,strong) NSString *strTotalDistance;
@property(nonatomic,strong) NSString *strTotalCost;

@end

#pragma mark - Modal SavedPlaces

@interface ModalSavedPlace : NSObject
@property(nonatomic,strong) NSString *strLocation;
@property(nonatomic,strong) NSString *strLocationTitle;
@property(nonatomic,strong) NSString *strLocationID;
@property(nonatomic,strong) NSString *strCoordinate;
@property(nonatomic,strong) NSString *strPickMeCoordinate;
@property(nonatomic,strong) NSString *strTakeMeCoordinate;
@property(nonatomic,strong) NSString *strLatitude;
@property(nonatomic,strong) NSString *strLongitude;
@property(nonatomic,strong) NSString *strAddress;
@property(nonatomic,strong) NSString *strTitle;
@end

#pragma mark - Modal SavedPlaces

@interface ModalComapreCost : NSObject
@property(nonatomic,strong) NSString *strPickMeName;
@property(nonatomic,strong) NSString *strTakeMeToName;
@property(nonatomic,strong) NSString *strAddress;
@property(nonatomic,strong) NSString *strPickMeCoordinate;
@property(nonatomic,strong) NSString *strTakeMeCoordinate;
@property(nonatomic,strong) NSString *strDistance;
@property(nonatomic,strong) NSString *strCompanyLogo;
@property(nonatomic,strong) NSString *strCompanyName;
@property(nonatomic,strong) NSString *strLyftName;
@property(nonatomic,strong) NSString *strLyftTime;
@property(nonatomic,strong) NSString *strEstimateTime;
@property(nonatomic,strong) NSString *strEstimateTimeinMin;
@property(nonatomic,strong) NSString *strEstimateCost;
@property(nonatomic,strong) NSString *strCompanyFare;
@property(nonatomic,strong) NSString *strNycTime;
@property(nonatomic,strong) NSString *strNycFare;
@property(nonatomic,strong) NSString *strUberFare;
@property(nonatomic,strong) NSString *strYellowName;
@property(nonatomic,strong) NSString *strGreenName;
@property(nonatomic,strong) NSString *strUberName;
@property(nonatomic,strong) NSString *strProductId;
@property(nonatomic,strong) NSString *strRideType;
@property(nonatomic,strong) NSString *strArrivalTime;

+(ModalComapreCost*)getdatadictionary:(NSDictionary*)dict withCompanyName:(NSString*)cabName;


//+(NSString*)getPriceData:(NSArray *)dataArray;
@end

@interface CountryDetailModal : NSObject

@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *countryPhoneCode;
@property (strong, nonatomic) NSString *countryFlagLink;
@property (assign, nonatomic) BOOL isSelected;

+(CountryDetailModal *)fetchAllCountryDetail:(NSDictionary *)countryDictionary;

@end


