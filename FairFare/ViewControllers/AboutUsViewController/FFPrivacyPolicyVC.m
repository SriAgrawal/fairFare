//
//  FFPrivacyPolicyVC.m
//  FairFareApp
//
//  Created by Shridhar Agarwal on 27/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "FFPrivacyPolicyVC.h"
#import "Header.h"

@interface FFPrivacyPolicyVC ()
{
    NSString *content;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIWebView *privacyWebView;
@property (weak, nonatomic) IBOutlet UILabel *navtitle;
- (IBAction)backAction:(id)sender;
@end
@implementation FFPrivacyPolicyVC

#pragma mark- Life cycle of view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - helper methods
-(void)initalSetUp
{
    self.navigationController.navigationBar.hidden = YES;
    if ([_navigationtitle isEqualToString:@"About App"])
    {
        [self callPrivacyApi:@"3"];
        self.navtitle.text = self.navigationtitle;
    }
    else
    {
        [self callPrivacyApi:@"1"];
        self.navtitle.text = self.navigationtitle;
    }
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
}

#pragma mark- Button Action Method
- (IBAction)backAction:(id)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}

/*********************** Service Implementation Methods ****************/

-(void)callPrivacyApi:(NSString*)pageID
{
    
    NSMutableDictionary *valueCode = [[NSMutableDictionary alloc] init];
    [valueCode setValue:pageID forKey:@"page_id"];
    [valueCode setValue:@"static_pages" forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueCode AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSMutableDictionary *dic = [result objectForKey:@"responseData"];
            content = [dic objectForKeyNotNull:@"content" expectedObj:@""];
            NSString *myHTML  = [ NSString stringWithFormat:@"<!DOCTYPE html><html><head></head><body>%@</body></html>",content];
            [ self.privacyWebView loadHTMLString:myHTML baseURL:nil];
            self.privacyWebView.dataDetectorTypes = UIDataDetectorTypeNone;
            
        } else
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
    }];
    
    
}
@end
