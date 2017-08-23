//
//  AHConstants.h
//  AHTO
//
//  Created by Sunil Verma on 12/25/14.
//  Copyright (c) 2014 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

//API names
extern NSString *kApiSignUp;
extern NSString *kApiLogin;
extern NSString *kApiForgot;
extern NSString *kApiChangePassword;
extern NSString *kApiSocialLogin;
extern NSString *kApiTermsAndCondition;
extern NSString *kApiLogout;
extern NSString *kApiFeedBack;

extern NSString *kApiEditProfile;
extern NSString *kApiMyProfile;
extern NSString *kApiSendInvitation;
extern NSString *kApiNearbyRides;

extern NSString *kApiRequestEstimate;
extern NSString *kApiRequest;
extern NSString *kGetUberAccessToken;
extern NSString *kApiRequestCurrent;
extern NSString *kApiMe;
extern NSString *kpEncryptionKey;
extern NSString *kGetLyftAccessToken;
//Parameter names
extern NSString *kIsLoggedIn;
extern NSString *kpUserName;
extern NSString *kpEmailID;
extern NSString *kpPassword;
extern NSString *kpFirstName;
extern NSString *kpLastName;
extern NSString *kpProfilePic;
extern NSString *kpCurrentPassword;
extern NSString *kpNewPassowrd;
extern NSString *kpSocialId;

extern NSString *kpUserid;
extern NSString *kpDeviceTokenid;
extern NSString *kpDeviceType;
extern NSString *kpAction;
extern NSString *kpContact;
extern NSString *kpConfirmationCode;
@interface ISConstants : NSObject

extern NSString *kClient_secret;
extern NSString *kClient_id;
extern NSString *kGrant_type;
extern NSString *kRedirect_uri;
extern NSString *kCode;

extern NSString *kStart_latitude;
extern NSString *kStart_longitude;
extern NSString *kEnd_latitude;
extern NSString *kEnd_longitude;

extern NSString *kFare;
extern NSString *kPrice;
extern NSString *kFare_id;
extern NSString *kProduct_id;
extern NSString *kRider_id;
extern NSString *kUser_Info;

extern NSString *kAccess_token;
extern NSString *kStatus;
extern NSString *kResponseMessage;
extern NSString *kResponseCode;
extern NSString *kIsRideInProgress;
extern NSString *kDestination;
extern NSString *kStartCoordinate;
extern NSString *kEndCoordinate;

extern NSString *kError;
extern NSString *kErrorDescription;

@end
