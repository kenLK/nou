//
//  LoginViewController.m
//  nou
//
//  Created by Ken on 2014/11/3.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "LoginViewController.h"
#import "IconViewController.h"
#import "Utility.h"
@interface LoginViewController ()

@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIAlertView *alertProcess;

-(UIColor *) colorFromHexString:(NSString *)hexString;
//-(NSString *) md5:(NSString *) input;

@end

@implementation LoginViewController
@synthesize account,password,alert,alertProcess;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Do any additional setup after loading the view from its nib.
    
    
    
    //開始產畫面
    
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    

    
    CGFloat appWidth = appRect.size.width;
    CGFloat appHeight = appRect.size.height;//screenRect.size.height;
    NSLog(@"appWidth>>>%f", appWidth);
    NSLog(@"appHeight>>>%f", appHeight);
    
    CGFloat yWidth = appWidth / 1200.0;
    CGFloat yHeight = appHeight / 1920.0;
    CGFloat modHeight = yHeight * 174 * -1;

    //背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *backImage = [UIImage imageWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"bg_V" ofType:@"jpg"]];
    [backImageView setImage:backImage];
    [self.view addSubview:backImageView];
    
    //logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*395, yHeight*1787 + modHeight, yWidth*410, yHeight*90)];
    UIImage *logoImage = [UIImage imageWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:@"icon_logo" ofType:@"png"]];
    [logoImageView setImage:logoImage];
    [self.view addSubview:logoImageView];
    
    //功能title
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, yWidth*1200, yHeight*174 + modHeight)];
//    UIImage *image = [UIImage imageWithContentsOfFile:
//                      [[NSBundle mainBundle] pathForResource:@"alpha_header_bg" ofType:@"png"]];
//    [imageView setImage:image];
//    [self.view addSubview:imageView];
//    
//    UILabel* functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0 + modHeight, yWidth*1200, yHeight*174)];
//    [functionTitleLabel setText:@"國立空中大學"];
//    [functionTitleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*60]];
//    functionTitleLabel.textColor = [UIColor whiteColor];
//    [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:functionTitleLabel];
    
    //標題
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*78, yHeight*290 + modHeight, yWidth*1044, yHeight*142)];
    [titleLabel setText:@"行動化服務系統"];
    [titleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*60]];
    titleLabel.backgroundColor = [self colorFromHexString:@"34aadc"];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    //欄位底色
    UIImageView *formBgView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*78, yHeight*432 + modHeight, yWidth*1044, yHeight*600)];
    UIImage *formBgImage = [UIImage imageWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"alpha_white_bg" ofType:@"png"]];
    [formBgView setImage:formBgImage];
    [self.view addSubview:formBgView];
    
    //帳號欄位底色
    UIImageView *accountBgView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*178, yHeight*504 + modHeight, yWidth*844, yHeight*100)];
    UIImage *accountBgImage = [UIImage imageWithContentsOfFile:
                            [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
    [accountBgView setImage:accountBgImage];
    [self.view addSubview:accountBgView];
    
    //帳號icon
    UIImageView *accountIconView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*202, yHeight*514 + modHeight, yWidth*80, yHeight*80)];
    UIImage *accountIconImage = [UIImage imageWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"icon_account" ofType:@"png"]];
    [accountIconView setImage:accountIconImage];
    [self.view addSubview:accountIconView];
    
    //帳號欄位
    account = [[UITextField alloc]initWithFrame:CGRectMake(yWidth*312, yHeight*504 + modHeight, yWidth*710, yHeight*100)];
    account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入帳號" attributes:@{NSForegroundColorAttributeName: [self colorFromHexString:@"000000"], NSFontAttributeName:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]}];
    [self.view addSubview:account];
    
    //帳號清除欄位資訊按鈕
    UIButton *clearAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearAccountButton.frame = CGRectMake(yWidth*942, yHeight*514 + modHeight, yWidth*80, yHeight*80);
    [clearAccountButton addTarget:self action:@selector(clearAccount:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *clearAccountImage = [UIImage imageWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"icon_clear" ofType:@"png"]];
    [clearAccountButton setImage:clearAccountImage forState:UIControlStateNormal];
    UIImage *clearAccountOverImage = [UIImage imageWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"icon_clear_over" ofType:@"png"]];
    [clearAccountButton setImage:clearAccountOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:clearAccountButton];
    
    //密碼欄位底色
    UIImageView *passwordBgView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*178, yHeight*634 + modHeight, yWidth*844, yHeight*100)];
    UIImage *passwordBgImage = [UIImage imageWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
    [passwordBgView setImage:passwordBgImage];
    [self.view addSubview:passwordBgView];
    
    //密碼icon
    UIImageView *passwordIconView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*202, yHeight*644 + modHeight, yWidth*80, yHeight*80)];
    UIImage *passwordIconImage = [UIImage imageWithContentsOfFile:
                                 [[NSBundle mainBundle] pathForResource:@"icon_password" ofType:@"png"]];
    [passwordIconView setImage:passwordIconImage];
    [self.view addSubview:passwordIconView];
    
    //密碼欄位
    password = [[UITextField alloc]initWithFrame:CGRectMake(yWidth*312, yHeight*634 + modHeight, yWidth*710, yHeight*100)];
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入密碼" attributes:@{NSForegroundColorAttributeName: [self colorFromHexString:@"000000"], NSFontAttributeName:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]}];
    password.secureTextEntry = YES;
    [self.view addSubview:password];
    
    //帳號清除欄位資訊按鈕
    UIButton *clearPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearPasswordButton.frame = CGRectMake(yWidth*942, yHeight*644 + modHeight, yWidth*80, yHeight*80);
    [clearPasswordButton addTarget:self action:@selector(clearPassword:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *clearPasswordImage = [UIImage imageWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"icon_clear" ofType:@"png"]];
    [clearPasswordButton setImage:clearPasswordImage forState:UIControlStateNormal];
    UIImage *clearPasswordOverImage = [UIImage imageWithContentsOfFile:
                                      [[NSBundle mainBundle] pathForResource:@"icon_clear_over" ofType:@"png"]];
    [clearPasswordButton setImage:clearPasswordOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:clearPasswordButton];
    
    //登入按鈕
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton addTarget:self
               action:@selector(login:)
     forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登入" forState:UIControlStateNormal];
    [loginButton setTitleColor:[self colorFromHexString:@"ffffff"] forState:UIControlStateNormal];
    loginButton.backgroundColor = [self colorFromHexString:@"f27935"];
    loginButton.frame = CGRectMake(yWidth*178, yHeight*842 + modHeight, yWidth*844, yHeight*100);
    [self.view addSubview:loginButton];
    
    //訪客登入按鈕
    UIButton *loginGuestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginGuestButton addTarget:self
                    action:@selector(loginGuest:)
          forControlEvents:UIControlEventTouchUpInside];
    
    //訪客登入按鈕底線文字
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"以訪客身份瀏覽"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];

    [loginGuestButton setAttributedTitle:commentString forState:UIControlStateNormal];
    [loginGuestButton setTitleColor:[self colorFromHexString:@"000000"] forState:UIControlStateNormal];
    loginGuestButton.frame = CGRectMake(yWidth*78, yHeight*432 + modHeight + yHeight*600 + yHeight*153, yWidth*1044, yHeight*100);
    [self.view addSubview:loginGuestButton];
    
    //Navigator圖示設定
    //移除登出按鈕99, 教務系統按鈕98
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if(view.tag == 99 || view.tag == 98)
        {
            [view removeFromSuperview];
        }
    }
    
    //Navigator圖示設定
    //功能title
    UILabel *functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, [Utility appHeight]*174)];
    [functionTitleLabel setText:@"國立空中大學"];
    functionTitleLabel.textColor = [Utility colorFromHexString:@"FFFFFF"];
    [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = functionTitleLabel;
    
    self.navigationController.navigationBar.barTintColor = [Utility colorFromHexString:@"34ADDC"];
    self.navigationController.navigationBar.translucent = NO;
    
    
    //寫入regId    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"regId"] != nil) {
        NSString *iOSDeviceToken = [[NSString alloc] initWithString:[userDefaults stringForKey:@"regId"]];
        NSString* urlString = [[NSString alloc] initWithFormat:@"regId=%@&type=IOS", iOSDeviceToken];
        [NouRequest urlMethod:@"reg" parameterString:urlString];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    
    NSLog(@"account>>>>%@<<<<",self.account.text);
    NSLog(@"password>>>>%@<<<<",self.password.text);
    
    NSString *pAccount = self.account.text;
    NSString *pPassword = self.password.text;
    
    [self goIconView:pAccount password:pPassword];
}

- (IBAction)loginGuest:(id)sender {
    [self goIconView:@"guest" password:@"guest"];
}


- (IBAction)clearAccount:(id)sender {
    [account setText:@""];
    [account resignFirstResponder];
}

- (IBAction)clearPassword:(id)sender {
    [password setText:@""];
    [password resignFirstResponder];
}

- (void) goIconView:(NSString *)acccountI password:(NSString *)passwordI {
    NSLog(@"account>>>>%@<<<<",acccountI);
    NSLog(@"password>>>>%@<<<<",passwordI);
    
    NSString *pAccount = acccountI;
    NSString *pPassword = passwordI;
    NSString *pRegId = @"";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    pRegId = [userDefaults stringForKey:@"regId"];
    
    //假如取不到推播token(使用者尚未開啟推播開啟，則輸入一個假的token)
    if ([@"" isEqualToString:pRegId] || pRegId == nil) {
        pRegId = @"testToken";
        
        //將Device Token傳給Provider...
        
        NSString* urlString = [[NSString alloc] initWithFormat:@"regId=%@&type=IOS", pRegId];
        [NouRequest urlMethod:@"reg" parameterString:urlString];
        
        [userDefaults setObject:pRegId forKey:@"regId"];
        [userDefaults synchronize];
    }
    
    //MD5
    pPassword = [Utility md5:passwordI];
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"account=%@&password=%@&regId=%@&type=IOS"
                           , pAccount, pPassword, pRegId];
    NSData *responseData =  [NouRequest urlMethod:@"login" parameterString:urlString];
    
    //    NSLog(@"statusCode>>%d", statusCode);
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] );
    
    NSDictionary *resultJSON;
    if (responseData != nil) {
        resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        NSString *RETURNCODE = [resultJSON objectForKey:@"RETURNCODE"];
        NSLog(@"%@", RETURNCODE);
        
        if ([@"00" isEqualToString:RETURNCODE]) {
            //登入成功
            
            //紀錄user data
            [userDefaults setObject:pAccount forKey:@"account"];
            [userDefaults setObject:pPassword forKey:@"password"];
            //[userDefaults setObject:pRegId forKey:@"regId"];
            [userDefaults setObject:[resultJSON objectForKey:@"PW"] forKey:@"VALID_STR"];
            [userDefaults synchronize];
            //
            UIViewController *iconViewController = [[IconViewController alloc] init];
            [self.navigationController setViewControllers:[NSArray arrayWithObject:iconViewController] animated:YES];
 
        } else {
            UILabel* functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, [Utility appHeight]*1052, [Utility appWidth]*1200, [Utility appHeight]*174)];
            [functionTitleLabel setText:@"帳號或密碼錯誤"];
            [functionTitleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*60]];
            functionTitleLabel.textColor = [UIColor redColor];
            [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:functionTitleLabel];
        }
    } else {
    
        [self errorNetwork];
    }

}

- (void) showAlert: (NSString*) title messsage: (NSString*) message {
    [alertProcess setTitle:title];
    [alertProcess setMessage:message];
}

- (void) showAlert: (NSString*) title messsage: (NSString*) message okBtn:(NSString*) okString {
    [alert setTitle:title];
    [alert setMessage:message];
}

-(UIColor *) colorFromHexString:(NSString *)hexString {
    return [Utility colorFromHexString:hexString];
}

-(void) errorNetwork {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"網路錯誤"
                                          message:@"網路連線錯誤"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"確定", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   //LoginViewController *newVC = [[LoginViewController alloc] init];
                                   
                                   //[self presentViewController:newVC animated:YES completion:nil];
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
