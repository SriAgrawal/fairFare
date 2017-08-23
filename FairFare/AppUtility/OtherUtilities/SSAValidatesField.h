//
//  NLValidatesField.h
//  NetLabApp
//
//  Created by Aditi Tiwari on 02/11/15.
//  Copyright © 2015 Aditi Tiwari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSAValidatesField : NSObject
+(BOOL)validateFirstName:(NSString *)firstName;
+(BOOL)validateLastName:(NSString *)lastName;
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;
+(BOOL)validateMobileNumber:(NSString *)mobileNumber;
+(BOOL)validateEmailAddress:(NSString *)emailAddress;
+(BOOL)validateAddress:(NSString *)address;
+(BOOL)validateUsername:(NSString *)userName;
+(BOOL)validateName:(NSString *)name;
+(BOOL) validateUrl: (NSString *) candidate ;
@end
