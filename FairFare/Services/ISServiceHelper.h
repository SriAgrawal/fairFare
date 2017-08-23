//
//  AHServiceHelper.h
//  MettingApp
//
//  Created by Sunil Verma on 7/22/14.
//  Copyright (c) 2014 Sunil Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BASE_URL @"https://api.ahto.me/"
// development purpose
//#define BASE_URL @"http://172.16.0.9/PROJECTS/InstaScene/trunk/api/"
//#define BASE_URL @"https://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/AmigoInstaScene/trunk/api/"


//Local URL
//#define BASE_URL @"http://172.16.0.9/PROJECTS/FareFare/trunk/services/"

// staging URL
//#define BASE_URL @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/FairFare/trunk/services/api_services.php"

//LiVe Url
#define BASE_URL @"http://ec2-52-205-31-116.compute-1.amazonaws.com/services/api_services.php"

#define Halio_url @"https://api.hailoapp.com/drivers/"
#define Lyft_url  @"https://api.lyft.com/v1/"
#define Uber_url  @"https://api.uber.com/v1/"
#define Google_url  @"https://maps.googleapis.com/maps/api/distancematrix/"
#define Nyc_url  @"https://data.cityofnewyork.us/resource/"
#define kHudHideAnimationTime   0.0

//#For Sandbox
//#define Uber_url  @"https://sandbox-api.uber.com/v1.2/"


@class RDUtility;

typedef enum {
    ISProgressNotShown = 0,
    ISProgressShown = 1
   
} ISProgressHud;

typedef void(^RequestComplitopnBlock)(id result, NSError  *error);

@interface ISServiceHelper : NSObject<NSURLConnectionDelegate>
{
    NSInteger responseCode;
     ISProgressHud progressHud;

}
@property (nonatomic, strong)    NSMutableData		   *downLoadedData;
@property (nonatomic, strong)    NSURLConnection       *connection;
@property (nonatomic, strong)    NSString              *userKey;
@property (nonatomic, strong)    NSString *token;
+(id)sharedInstance;

-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict AndApiType:(NSString *)apiType WithComptionBlock:(RequestComplitopnBlock)block;
-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict AndApitype:(long)apiType AndAPIName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block;
+(void)PostAPICallWithParameterNewConnection:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block;
-(void)PostAPICallWithParameters:(NSMutableDictionary *)parameterDict AndApiType:(NSUInteger)apiType andApiName:(NSString *)ApiName WithComptionBlock:(RequestComplitopnBlock)block;
-(void)DeleteAPICallWithParameters:(NSMutableDictionary *)parameterDict AndApiType:(NSUInteger)apiType andApiName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block;
- (void)cancelConnection;

@end
