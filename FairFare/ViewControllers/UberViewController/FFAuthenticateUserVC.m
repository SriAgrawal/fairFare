//
//  FFAuthenticateUserVC.m
//  FairFareApp
//
//  Created by Suresh patel on 29/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "Header.h"

@interface FFAuthenticateUserVC ()

@property (strong, nonatomic) IBOutlet UIWebView        * webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation FFAuthenticateUserVC

#pragma mark- View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaults];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // loading indicator


    if ([_serviceName isEqualToString:@"Uber"]) {
        
          [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://login.uber.com/oauth/v2/authorize?client_id=%@&response_type=code&redirect_uri=%@", CLIENT_ID,REDIRECT_URL]]]];
    }
    else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.lyft.com/oauth/authorize?client_id=0UMnmmRqa8m_&scope=public%20profile%20rides.read%20rides.request&state=TW9uIEp1bCAxMCAyMDE3IDE2OjMxOjIzIEdNVCswNTMwIChJU1Qp&response_type=code"]]];
    }

}

#pragma mark- Class Instance Method.

-(void)setupDefaults{
    
}

#pragma mark- IBAction Methods

-(IBAction)doneButtonAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
    
}

#pragma mark - UIWebView Delegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if ([_serviceName isEqualToString:@"Uber"]) {
    
    NSArray * urlContent = [request.URL.absoluteString componentsSeparatedByString:@"code="];
    if (urlContent.count == 2) {
        
        [self callWebApiToGetAccessTokenWithCode:[[urlContent lastObject] stringByReplacingOccurrencesOfString:@"#_" withString:@""]];
        return NO;
    }
        return YES;
    }else{
        
        NSArray * urlContent = [request.URL.absoluteString componentsSeparatedByString:@"code="];
        if (urlContent.count == 2) {
            NSArray * codeContent = [[urlContent lastObject] componentsSeparatedByString:@"&"];
            if (codeContent.count == 2) {
                [self callWebApiToGetAccessTokenForLyftWithCode:[codeContent firstObject]];
            }
            return NO;
        }
        return YES;
    }
}

-(void)callWebApiToGetAccessTokenWithCode:(NSString *)code{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:CLIENT_ID forKey:kClient_id];
    [paramDict setValue:CLIENT_SECRET forKey:kClient_secret];
    [paramDict setValue:@"authorization_code" forKey:kGrant_type];
    [paramDict setValue:REDIRECT_URL forKey:kRedirect_uri];
    [paramDict setValue:kGetUberAccessToken forKey:kpAction];
    [paramDict setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [paramDict setValue:code forKey:kCode];

    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:0 andApiName:kApiRequestEstimate WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSDictionary * userDict = [result objectForKeyNotNull:kUser_Info expectedObj:[NSDictionary dictionary]];
            [NSUSERDEFAULT setValue:[result objectForKeyNotNull:kAccess_token expectedObj:@""] forKey:kAccess_token];
            [NSUSERDEFAULT setValue:[userDict objectForKeyNotNull:kRider_id expectedObj:@""] forKey:kRider_id];
            [NSUSERDEFAULT synchronize];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(didReceiveAccessToken:)])
                    [self.delegate didReceiveAccessToken:[result objectForKeyNotNull:kAccess_token expectedObj:@""]];
            }];

            //[self getCurrentRideInformationWithToken:[responseDict objectForKeyNotNull:kAccess_token expectedObj:@""]];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}







-(void)callWebApiToGetAccessTokenForLyftWithCode:(NSString *)code{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:LYFTCLIENT_ID forKey:kClient_id];
    [paramDict setValue:LYFTCLIENT_SECRET forKey:kClient_secret];
    [paramDict setValue:@"authorization_code" forKey:kGrant_type];
    [paramDict setValue:kGetLyftAccessToken forKey:kpAction];
    [paramDict setValue:[NSUSERDEFAULT valueForKey:kpUserid] forKey:kpUserid];
    [paramDict setValue:code forKey:kCode];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameters:paramDict AndApiType:0 andApiName:nil WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSDictionary * userDict = [result objectForKeyNotNull:kUser_Info expectedObj:[NSDictionary dictionary]];
            [NSUSERDEFAULT setValue:[result objectForKeyNotNull:kAccess_token expectedObj:@""] forKey:kAccess_token];
            [NSUSERDEFAULT setValue:[userDict objectForKeyNotNull:kRider_id expectedObj:@""] forKey:kRider_id];
            [NSUSERDEFAULT synchronize];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(didReceiveAccessToken:)])
                    [self.delegate didReceiveAccessToken:[result objectForKeyNotNull:kAccess_token expectedObj:@""]];
            }];
            
            //[self getCurrentRideInformationWithToken:[responseDict objectForKeyNotNull:kAccess_token expectedObj:@""]];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
        else
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

-(void)getCurrentRideInformationWithToken:(NSString *)accessToken{
    
    [[ISServiceHelper sharedInstance] GetAPICallWithParameter:nil AndApitype:2 AndAPIName:kApiMe WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [NSUSERDEFAULT setValue:[result objectForKeyNotNull:kRider_id expectedObj:@""] forKey:kRider_id];
            [NSUSERDEFAULT synchronize];

            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(didReceiveAccessToken:)])
                    [self.delegate didReceiveAccessToken:accessToken];
            }];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 401)
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else if ([[result objectForKey:@"responseCode"] integerValue] == 404)
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        
        else
        {
            [AlertController title:@"" message:[result  valueForKey:@"message"] andButtonsWithTitle:@[@"OK"] onViewController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}


@end
