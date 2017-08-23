//
//  AHServiceHelper.m
//  MettingApp
//
//  Created by Sunil Verma on 7/22/14.
//  Copyright (c) 2014 Sunil Verma. All rights reserved.
//

#import "ISServiceHelper.h"
#import "Header.h"
#import "MBProgressHUD.h"

@interface NSDictionary(JSONCategories)

+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData;
-(NSData*)toJSON;

@end
@interface ISServiceHelper () {
    
    MBProgressHUD *progressHUD;
}
@end
@implementation NSDictionary(JSONCategories)
+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData
{
    __autoreleasing NSError* error = nil;
    if(JSONData == nil) {
        return [NSDictionary dictionary];
    
    }
    id result = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result ;
}

-(id)toJSON
{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    if (error != nil) return nil;
    return result;
}
@end


@implementation ISServiceHelper
@synthesize downLoadedData;
@synthesize connection;
@synthesize userKey;
RequestComplitopnBlock  responseBlock;


static ISServiceHelper *helper = nil;

+(id)sharedInstance
{
    @synchronized(self) {
        
        if (!helper) {
            
            helper = [[ISServiceHelper alloc] init];
        }
    }
    return helper;
}

-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict AndApitype:(long)apiType AndAPIName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error!",nil) message:@"Unable to connect network, Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        responseBlock(nil,error);
        return;
    }
    switch (apiType)
    {
        case 0:
        {
        
            NSMutableString *urlString;
            urlString = [NSMutableString stringWithFormat:@"%@%@", Halio_url, apiName];
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"PhotoImports"] == YES){
                urlString = [NSMutableString stringWithFormat:@"%@", apiName];
            }
            BOOL isFirst = YES;
            
            for (NSString *key in [parameterDict allKeys]) {
                
                id object = parameterDict[key];
                if ([object isKindOfClass:[NSArray class]]) {
                    
                    for (id eachObject in object) {
                        [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                        isFirst = NO;
                    }
                }
                else{
                    [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
                }
                
                isFirst = NO;
            }
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"token DrTFKrEAyMuD2aCkLe3sniDFrwWk4MCf2M9dpSGIEGGj4CZ+oncVOtB7YxUJM3Zn3tpnc4Ti1fPJ9BfY7jCB24Y3X1n4UvtLhuiCQqsVgLy/3i14x16Ze1kI2HGFGGLy+Bp6e5JlwFKrv5UPhTwMQFKp5ZfyHU1Ae0ZcTtLzvnXAfa38ZV7R2Y018qApMyXXlNoZOJoKUzmNhzmpUVm0og==" forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[NSData data]];
            [request setTimeoutInterval:10.0];
            
            [self setProgressHud:ISProgressShown];
             self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            break;
        
    case 1:
        {
            
            NSMutableString *urlString;
            urlString = [NSMutableString stringWithFormat:@"%@%@", Lyft_url, apiName];
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"PhotoImports"] == YES){
                urlString = [NSMutableString stringWithFormat:@"%@", apiName];
            }
            BOOL isFirst = YES;
            
            for (NSString *key in [parameterDict allKeys]) {
                
                id object = parameterDict[key];
                if ([object isKindOfClass:[NSArray class]]) {
                    
                    for (id eachObject in object) {
                        [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                        isFirst = NO;
                    }
                }
                else{
                    [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
                }
                
                isFirst = NO;
            }
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%@ %@",[NSUSERDEFAULT valueForKey:@"token_type"],[NSUSERDEFAULT valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[NSData data]];
            [request setTimeoutInterval:10.0];
            
            [self setProgressHud:ISProgressShown];
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];

            
        }
        break;
        
    case 2:
        {
            NSMutableString *urlString;
            urlString = [NSMutableString stringWithFormat:@"%@%@", Uber_url, apiName];
            BOOL isFirst = YES;
            
            for (NSString *key in [parameterDict allKeys]) {
                
                id object = parameterDict[key];
                if ([object isKindOfClass:[NSArray class]]) {
                    
                    for (id eachObject in object) {
                        [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                        isFirst = NO;
                    }
                }
                else{
                    [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
                }
                
                isFirst = NO;
            }
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", [NSUSERDEFAULT valueForKey:kAccess_token]] forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[NSData data]];
            [request setTimeoutInterval:20.0];
            
            [self setProgressHud:ISProgressShown];
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
            
        }
        break;
       
        case 3:
        {
            
            
            NSMutableString *urlString;
            urlString = [NSMutableString stringWithFormat:@"%@%@", Google_url, apiName];
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"PhotoImports"] == YES){
                urlString = [NSMutableString stringWithFormat:@"%@", apiName];
            }
            BOOL isFirst = YES;
            
            for (NSString *key in [parameterDict allKeys]) {
                
                id object = parameterDict[key];
                if ([object isKindOfClass:[NSArray class]]) {
                    
                    for (id eachObject in object) {
                        [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                        isFirst = NO;
                    }
                }
                else{
                    [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
                }
                
                isFirst = NO;
            }
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[NSData data]];
            [request setTimeoutInterval:10.0];
            
            [self setProgressHud:ISProgressShown];
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
            
        }
             break;
        
        default:
            break;
    }
    
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        downLoadedData = [NSMutableData data];
        
    }
}

-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict AndApiType:(NSString *)apiType WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error!",nil) message:@"Unable to connect network, Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];        responseBlock(nil,error);
        return;
    }
    
    
    if ([apiType isEqualToString:@"Normal"])
    {
        NSString *urlString =[NSString stringWithFormat:@"%@", BASE_URL];
        ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[parameterDict toJSON]];
        [request setTimeoutInterval:45.0];
        //NSLog(@"Post request body ==%@", [parameterDict toJSON]);
      
        self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        NSString *urlString =[NSString stringWithFormat:@"%@",@"https://api.lyft.com/oauth/token"];
        //ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"Basic bWZmU0dhdDh5ejl3OjlQbHpLNXVKRk4tbU13X29zdUZMVjBSaXRSb3hldWtN" forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:[parameterDict toJSON]];
        [request setTimeoutInterval:45.0];
        
       // NSLog(@"Post request body ==%@", [parameterDict toJSON]);
        
        self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    }
 
    [self setProgressHud:ISProgressShown];

    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        downLoadedData = [NSMutableData data];
    }
}

-(void)PostAPICallWithParameters:(NSMutableDictionary *)parameterDict AndApiType:(NSUInteger)apiType andApiName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error!",nil) message:@"Unable to connect network, Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];        responseBlock(nil,error);
        return;
    }
    
    switch (apiType) {
        case 0:
        {
            NSString *urlString =[NSString stringWithFormat:@"%@", BASE_URL];
            ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[parameterDict toJSON]];
            [request setTimeoutInterval:45.0];
            
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            break;
            
        case 1:
        {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", Lyft_url, apiName];
            //ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"bearer %@", [NSUSERDEFAULT valueForKey:kAccess_token]] forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[parameterDict toJSON]];
            [request setTimeoutInterval:45.0];
            
            // NSLog(@"Post request body ==%@", [parameterDict toJSON]);
            
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            break;
            
        case 2:
        {
            NSString *urlString =[NSString stringWithFormat:@"%@%@", Uber_url, apiName];
            //ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", [NSUSERDEFAULT valueForKey:kAccess_token]] forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[parameterDict toJSON]];
            [request setTimeoutInterval:45.0];
            
            // NSLog(@"Post request body ==%@", [parameterDict toJSON]);
            
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            break;
            
        default:
            break;
    }
    
    [self setProgressHud:ISProgressShown];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        downLoadedData = [NSMutableData data];
    }
}


+(void)PostAPICallWithParameterNewConnection:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block
{
    
    RequestComplitopnBlock  responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error!",nil) message:@"Unable to connect network, Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        responseBlock(nil,error);
        return;
    }
    
    
    //    if ([self isTokenRequired:apiName]) {
    //
    //        [parameterDict setObject:self.token forKey:pToken];
    //    }
    //
    NSString *urlString =[NSString stringWithFormat:@"%@%@", BASE_URL, apiName];
    //  ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[parameterDict toJSON]];
    [request setTimeoutInterval:45.0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
        responseBlock(result,connectionError);
    }];
    
}

-(void)DeleteAPICallWithParameters:(NSMutableDictionary *)parameterDict AndApiType:(NSUInteger)apiType andApiName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error!",nil) message:@"Unable to connect network, Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];        responseBlock(nil,error);
        return;
    }
    
    switch (apiType) {
        case 1:
        {
            NSString *urlString =[NSString stringWithFormat:@"%@",@"https://api.lyft.com/oauth/token"];
            //ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            [request setHTTPMethod:@"DELETE"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"Basic bWZmU0dhdDh5ejl3OjlQbHpLNXVKRk4tbU13X29zdUZMVjBSaXRSb3hldWtN" forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[parameterDict toJSON]];
            [request setTimeoutInterval:45.0];
            
            // NSLog(@"Post request body ==%@", [parameterDict toJSON]);
            
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            break;
            
        case 2:
        {
            NSString *urlString =[NSString stringWithFormat:@"%@%@", Uber_url, apiName];
            //ATLog(@"fgdfgd %@ %@",urlString,parameterDict);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            
            [request setHTTPMethod:@"DELETE"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", [NSUSERDEFAULT valueForKey:kAccess_token]] forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:[parameterDict toJSON]];
            [request setTimeoutInterval:45.0];
            
            // NSLog(@"Post request body ==%@", [parameterDict toJSON]);
            
            self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
            break;
            
        default:
            break;
    }
    
    [self setProgressHud:ISProgressShown];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        downLoadedData = [NSMutableData data];
    }
}





- (void)setProgressHud:(ISProgressHud)hud {
    progressHud = hud;
    switch (progressHud) {
        case ISProgressShown:
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];
            break;
        case ISProgressNotShown:
            break;
        default:
            break;
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:    (NSURLProtectionSpace *)protectionSpace {
    // NSLog(@"canAuthenticateAgainstProtectionSpace:");
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:    (NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential     credentialForTrust:challenge.protectionSpace.serverTrust]     forAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *responseString = [[NSString alloc] initWithData:downLoadedData encoding:NSUTF8StringEncoding];
    ATLog(@"FINISH LOADING :  %ld  %@",(long)responseCode,responseString);
    
    id result = [NSDictionary dictionaryWithContentsOfJSONURLData:downLoadedData];
    NSMutableDictionary * responseDict = [NSMutableDictionary dictionaryWithDictionary:result];
    
    if (![[result objectForKeyNotNull:kResponseCode expectedObj:@""] length]) {
        [responseDict setValue:[NSString stringWithFormat:@"%ld", (long)responseCode] forKey:kResponseCode];
    }
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    
   // [ISUtility enableGesture];
    progressHUD = nil;
    responseBlock(responseDict,nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSString *responseString = [[NSString alloc] initWithData:downLoadedData encoding:NSUTF8StringEncoding];
//   ATLog(@"FAIL WITH LOADING : %ld   %@ and Error %@",responseCode,responseString,error);
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error!",nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];        responseBlock(nil,error);

   // showAlert(@"Error!", [error localizedDescription],@"Ok",self,@"");
//  [APPDELEGATE showAlertWithTitle:@"Error!" message:[error localizedDescription]];
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    progressHUD = nil;
    
    responseBlock(nil,error);
   // [ISUtility enableGesture];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [downLoadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    responseCode = (int)[HTTPResponse statusCode];
    [self setProgressHud:ISProgressNotShown];

    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    progressHUD = nil;

}

- (void)cancelConnection
{
    if(self.connection){
        [self.connection cancel];
        self.connection = nil;
        
    }
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    progressHUD = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  //  [ISUtility enableGesture];
}

@end
