//
//  FFProfileViewController.m
//  FairFare
//
//  Created by Ankit Kumar Gupta on 08/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFProfileViewController.h"
#import "FFProfileTableViewCell.h"

@interface FFProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate> {
    
    UserInfo *modalObj;

}

@property (strong, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (strong, nonatomic) IBOutlet UIButton *camerBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (assign, nonatomic) BOOL  isEdit;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *profileTableView;

@end

@implementation FFProfileViewController

#pragma mark- Life cycle of view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpDefaults];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}



#pragma mark- Helper Methods

-(void) setUpDefaults {
    
    self.navigationController.navigationBar.hidden = YES;
    modalObj = [[UserInfo alloc]init];
    [_profileTableView registerNib:[UINib nibWithNibName:@"FFProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"FFProfileTableViewCell"];
    
    [self callViewProfileApi];
}


#pragma mark- UITabelView Delegates and DataSources Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FFProfileTableViewCell *cell = (FFProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FFProfileTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textFieldCell.delegate = self;
    if (self.isEdit) {
        cell.viewCell.layer.borderColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5].CGColor;
        cell.viewCell.layer.borderWidth = 1.0;
        cell.textFieldCell.userInteractionEnabled = YES;

    }else{
        cell.viewCell.layer.borderColor =  [UIColor clearColor].CGColor;
        cell.viewCell.layer.borderWidth = 0;
        cell.textFieldCell.userInteractionEnabled = NO;

    }
    cell.textFieldCell.returnKeyType = UIReturnKeyNext;
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell.labelCell.text = @"First Name";
                    cell.textFieldCell.text = modalObj.firstName;
                    cell.textFieldCell.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    cell.textFieldCell.tag = 1000;
                }
                    break;
                case 1: {
                    cell.labelCell.text = @"Last Name";
                    cell.textFieldCell.text = modalObj.lastName;
                    cell.textFieldCell.autocapitalizationType = UITextAutocapitalizationTypeWords;
                    cell.textFieldCell.tag = 1001;


                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    cell.labelCell.text = @"Phone ";
                    cell.textFieldCell.text =modalObj.strContact;
                    cell.textFieldCell.userInteractionEnabled = NO;
                    cell.viewCell.layer.borderColor =  [UIColor clearColor].CGColor;
                    cell.viewCell.layer.borderWidth = 0;
                    cell.textFieldCell.tag = 1002;

                }
                    break;
                case 1: {
                    cell.labelCell.text = @"Email";
                    cell.textFieldCell.text = modalObj.strEmail;
                    cell.textFieldCell.keyboardType = UIKeyboardTypeEmailAddress;
                    cell.textFieldCell.tag = 1003;
                    cell.textFieldCell.returnKeyType = UIReturnKeyDone;


                }
                    break;
                default:
                    break;
            }
            
        }
            
            break;
            
        default:
            break;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 30)];
    
    lbl.text = section == 0 ? @"Personal" : @"Contacts";
    lbl.font = AppFont(12);
    lbl.textColor = [UIColor lightGrayColor];
    [view addSubview:lbl];
    return view;
}


#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(PATextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        [[self.profileTableView viewWithTag:textField.tag+1 == 1002?1003:textField.tag+1] becomeFirstResponder];
    } else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 1000:
            modalObj.firstName = textField.text;
            break;
        case 1001:
            modalObj.lastName = textField.text;
            break;
        case 1002:
            modalObj.strContact = textField.text;
            break;
        case 1003:
            modalObj.strEmail = textField.text;
            break;
        default:
            break;
    }
}

-(BOOL)isVerified
{
    BOOL isverified = YES;
    
    if (![(modalObj.firstName) length])
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter first name." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
        
    }
    else  if ([SSAValidatesField validateName:modalObj.firstName])
    {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter valid first name." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
    else  if (![(modalObj.lastName) length])
    {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter last name." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
    else  if ([SSAValidatesField validateName:modalObj.lastName])
    {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter valid last name." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
   else if (![TRIM_SPACE(modalObj.strEmail) length])
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter email." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
    else  if ([SSAValidatesField validateEmailAddress:modalObj.strEmail])
    {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter valid email." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
    
    else {
        
        isverified = NO;
    }
    return isverified;
}

#pragma mark- UIButton Actions

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_isFromSetting) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
            if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissToHomeController)]) {
                [self.delegate dismissToHomeController];
            }
        }];
    }
}

- (IBAction)editBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.editBtn.selected) {
        
        [self.editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [self.editBtn setSelected:NO];
        self.isEdit =NO;
        [self.saveBtn setHidden:YES];

    }else{
        [self.editBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.editBtn setSelected:YES];
        self.isEdit =YES;
        [self.saveBtn setHidden:NO];
    }
    [self.profileTableView reloadData];
   
}


- (IBAction)saveBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self isVerified]) {
        [self callUpdateProfileApi];
       // [self.profileTableView reloadData];
    }
}

- (IBAction)camerBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.isEdit) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [[ActionSheet sheetManager] presentSheetWithTitle:nil message:nil cancelBttonTitle:@"Cancel" destrictiveButtonTitle:nil andButtonsWithTitle:@[@"Take a Photo",@"Choose from Gallery"] onController:self dismissedWith:^(NSInteger index,NSString *buttonTitle){
            
            switch (index) {
                    //photo library
                case 0:{
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;                    [self.navigationController presentViewController:picker animated:YES completion:nil];
                    }
                    else
                    {
                        [[AlertView sharedManager] presentAlertWithTitle:@"" message: @"Device has no camera" andButtonsWithTitle:@[@"OK"] onController:self                                                        dismissedWith:^(NSInteger index, NSString *buttonTitle) {                                                       }];
                    }
                }
                    break;
                    
                case 1:{
                    picker.sourceType =                                           UIImagePickerControllerSourceTypePhotoLibrary;
                    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
                    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
                    picker.allowsEditing = NO;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                    break;
                default:
                    return;
                    break;
            }
        }];
    }
}

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    UIImage *temp = image;
    self.userProfileImageView.image = temp;
    
    NSData *imageData = UIImageJPEGRepresentation(temp, 0.2);
    modalObj.strImageData = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)callViewProfileApi
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:kApiMyProfile forKey:kpAction];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            NSMutableDictionary *responseData = [result objectForKey:@"responseData"];
            
            modalObj.strName = [responseData objectForKeyNotNull:@"name" expectedObj:@""];
            modalObj.firstName = [responseData objectForKeyNotNull:@"first_name" expectedObj:@""];
            modalObj.lastName = [responseData objectForKeyNotNull:@"last_name" expectedObj:@""];

            modalObj.strEmail = [responseData objectForKeyNotNull:@"email" expectedObj:@""];
            modalObj.strContact = [responseData objectForKeyNotNull:@"contact" expectedObj:@""];
            modalObj.strImage = [responseData objectForKeyNotNull:@"image" expectedObj:@""];
            
            
            [self.userProfileImageView setImageWithURL:[NSURL URLWithString:modalObj.strImage] placeholderImage:[UIImage imageNamed:@"profile_placeholder"]];
            
            [self.profileTableView reloadData];
        } else
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
    }];
}



-(void)callUpdateProfileApi
{
    NSMutableDictionary *valueProfile = [[NSMutableDictionary alloc] init];
    [valueProfile setValue:[NSUSERDEFAULT valueForKey:kpUserid ] forKey:kpUserid];
    [valueProfile setValue:@"update_profile" forKey:kpAction];
    [valueProfile setValue:modalObj.firstName forKey:@"first_name"];
    [valueProfile setValue:modalObj.lastName forKey:@"last_name"];
    [valueProfile setValue:modalObj.strEmail forKey:@"email"];

    [valueProfile setValue:modalObj.strContact forKey:@"contact"];
    [valueProfile setValue:modalObj.strImageData.length?modalObj.strImageData:@"" forKey:@"image"];
    
    //[valueProfile setValue:[NSUSERDEFAULT valueForKey:kpSocialId ] forKey:kpSocialId];
    
    [[ISServiceHelper sharedInstance] PostAPICallWithParameter:valueProfile AndApiType:@"Normal" WithComptionBlock:^(id result, NSError *error) {
        if([[result objectForKey:@"responseCode"] integerValue] == 200)
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
             {
                 
                 [self.editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
                 [self.editBtn setSelected:NO];
                 self.isEdit =NO;
                 [self.saveBtn setHidden:YES];
                 [self callViewProfileApi];
             }];
            
        }
        else
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKey:@"responseMessage"]
                                         andButtonsWithTitle:@[@"Ok"] onController:self
             
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               }];
        }
    }];
}





#pragma mark- Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
