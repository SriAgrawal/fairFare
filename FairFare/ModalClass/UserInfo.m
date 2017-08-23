//
//  UserInfo.m
//  FairFareApp
//
//  Created by Shridhar Agarwal on 26/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "UserInfo.h"
#import "Header.h"
#import "AESCrypt.h"

@implementation UserInfo


@end

@implementation ModalHome

@end

@implementation ModalLoginIn
@end

@implementation ModalSignUp
@end


@implementation ModalConfimationCode
@end

@implementation ModalChangePassword

@end

@implementation ModalRiderList
@end

@implementation ModalTrips

@end
@implementation ModalInvoice
+(ModalInvoice*)getInvoiceOfDetails:(NSDictionary*)dict{

    ModalInvoice *invoiceObj = [[ModalInvoice alloc] init];
    invoiceObj.strTotalCharge = [dict objectForKeyNotNull:@"total_charged" expectedObj:@""];
    invoiceObj.strTotalDistance = [dict objectForKeyNotNull:@"distance" expectedObj:@""];
    invoiceObj.strTotalDuration = [dict objectForKeyNotNull:@"duration" expectedObj:@""];
    invoiceObj.strTotalFare = [dict objectForKeyNotNull:@"total_fare" expectedObj:@""];
    invoiceObj.strSubTotal = [dict objectForKeyNotNull:@"subtotal" expectedObj:@""];
    
    
    return invoiceObj;
}
@end

@implementation ModalDriverInfo

+(ModalDriverInfo*)getDriverDetails:(NSDictionary*)dict{

    ModalDriverInfo *driverObj = [[ModalDriverInfo alloc] init];
        NSMutableDictionary *driverDic = [dict objectForKeyNotNull:@"driver" expectedObj:[NSDictionary dictionary]];
        NSMutableDictionary *vehicleDic = [dict objectForKeyNotNull:@"vehicle" expectedObj:[NSDictionary dictionary]];
    
    driverObj.strDriverName = [driverDic objectForKeyNotNull:@"name" expectedObj:@""];
    driverObj.strDriverMobileNo = [driverDic objectForKeyNotNull:@"phone_number" expectedObj:@""];
    driverObj.strDriverImageInfo = [driverDic objectForKeyNotNull:@"picture_url" expectedObj:@""];
    driverObj.strDriverVechileNo = [vehicleDic objectForKeyNotNull:@"license_plate" expectedObj:@""];
    driverObj.strDriverVechileName = [NSString stringWithFormat:@"%@ %@",[vehicleDic objectForKeyNotNull:@"make" expectedObj:@""],[vehicleDic objectForKeyNotNull:@"model" expectedObj:@""]];
 
    return driverObj;
}

@end
@implementation ModalFeedback

@end
@implementation ModalSavedPlace

@end

@implementation ModalComapreCost


+(ModalComapreCost*)getdatadictionary:(NSDictionary*)dict withCompanyName:(NSString*)cabName
{
    ModalComapreCost *obj = [[ModalComapreCost alloc] init];
    if ([cabName isEqualToString:@"Yellow"])
    {
        obj.strYellowName = @"Yellow Taxi";
        obj.strNycTime =  [dict objectForKeyNotNull:@"trip_time" expectedObj:@""];
        obj.strNycFare =  [dict objectForKeyNotNull:@"amount" expectedObj:@""];
        obj.strCompanyLogo = @"YellowTaxi";
        
    }
    else if ([cabName isEqualToString:@"Uber"])
    {
        obj.strUberName = @"Uber";
        obj.strNycTime =  [dict objectForKeyNotNull:@"trip_time" expectedObj:@""];
    obj.strNycFare = [NSString stringWithFormat:@"%0.2f",([[dict objectForKeyNotNull:@"amount" expectedObj:@""] floatValue]*0.85)];
       // NSLog(@"%@",obj.strNycFare);
        obj.strEstimateCost = [dict objectForKeyNotNull:@"amount" expectedObj:@""];
        obj.strCompanyLogo = @"uber_img";
    }
    else
    {
        obj.strGreenName = @"Green Taxi";
        obj.strNycTime =  [dict objectForKeyNotNull:@"trip_time" expectedObj:@""];
        obj.strNycFare =  [dict objectForKeyNotNull:@"amount" expectedObj:@""];
        obj.strCompanyLogo = @"GreenTaxi";
    }

    return obj;
}

@end

#pragma mark - Modal Payment Method

@implementation ModalPaymentInfo : NSObject

+(NSMutableArray*)getPaymentMethodDetails:(NSMutableArray*)payArray{

    NSMutableArray *paymentArray = [[NSMutableArray alloc] init];
    
    if ([payArray isKindOfClass:[NSArray class]]) {
        for (NSMutableDictionary *dic in payArray) {
            ModalPaymentInfo *obj = [[ModalPaymentInfo alloc] init];
            obj.strPaymentId = [dic objectForKeyNotNull:@"card_id" expectedObj:@""];
            obj.strPaymentMethodName = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"card_type" expectedObj:@""]];
            
            NSString *cardStr = [AESCrypt decrypt:[dic objectForKeyNotNull:@"card_number" expectedObj:@""] password:kpEncryptionKey];
            
            obj.strOriginalCardNumber = cardStr;
            NSString *trimmedString=[cardStr substringFromIndex:MAX((int)[cardStr length]-4, 0)]; //in case string is less than 4 characters long.
            obj.strPaymentCardNumber = [NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",trimmedString];

            obj.strCardate =[AESCrypt decrypt:[dic objectForKeyNotNull:@"card_date" expectedObj:@""] password:kpEncryptionKey];
            [paymentArray addObject:obj];
        }
    }
    
   
    return  paymentArray;
}

@end
#pragma mark - Modal Payment Method

@implementation CountryDetailModal : NSObject

+(CountryDetailModal *)fetchAllCountryDetail:(NSDictionary *)countryDictionary {
    
    CountryDetailModal *countryDetail = [CountryDetailModal new];
    
    countryDetail.countryName = [countryDictionary objectForKeyNotNull:@"country_code" expectedObj:@""];
    countryDetail.countryPhoneCode = [countryDictionary objectForKeyNotNull:@"dial_code" expectedObj:@""];
    countryDetail.countryFlagLink = [countryDictionary objectForKeyNotNull:@"flag_url" expectedObj:@""];
    countryDetail.isSelected = NO;
    
    return countryDetail;
}

@end


