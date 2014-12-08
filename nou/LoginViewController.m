//
//  LoginViewController.m
//  nou
//
//  Created by Ken on 2014/11/3.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "LoginViewController.h"
#import "FistViewController.h"
#import "IconViewController.h"
@interface LoginViewController ()

@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIAlertView *alertProcess;

-(UIColor *) colorFromHexString:(NSString *)hexString;
-(NSString *) md5:(NSString *) input;

@end

@implementation LoginViewController
@synthesize account,password,alert,alertProcess;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;//screenRect.size.height;
    NSLog(@"screenWidth>>>%f", screenWidth);
    NSLog(@"screenHeight>>>%f", screenHeight);
    
    CGFloat yWidth = screenWidth / 1200.0;
    CGFloat yHeight = screenHeight / 1920.0;

    //背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, yWidth*1200, yHeight*1920)];
    UIImage *backImage = [UIImage imageWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"bg_V" ofType:@"jpg"]];
    [backImageView setImage:backImage];
    [self.view addSubview:backImageView];
    
    //logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*395, yHeight*1787, yWidth*410, yHeight*90)];
    UIImage *logoImage = [UIImage imageWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:@"icon_logo" ofType:@"png"]];
    [logoImageView setImage:logoImage];
    [self.view addSubview:logoImageView];
    
    //功能title
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, yWidth*1200, yHeight*174)];
    UIImage *image = [UIImage imageWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"alpha_header_bg" ofType:@"png"]];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    UILabel* functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, yWidth*1200, yHeight*174)];
    [functionTitleLabel setText:@"國立空中大學"];
    [functionTitleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*60]];
    functionTitleLabel.textColor = [UIColor whiteColor];
    [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:functionTitleLabel];
    
    //標題
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*78, yHeight*290, yWidth*1044, yHeight*142)];
    [titleLabel setText:@"行動化服務系統"];
    [titleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*60]];
    titleLabel.backgroundColor = [self colorFromHexString:@"34aadc"];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    //欄位底色
    UIImageView *formBgView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*78, yHeight*432, yWidth*1044, yHeight*600)];
    UIImage *formBgImage = [UIImage imageWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:@"alpha_white_bg" ofType:@"png"]];
    [formBgView setImage:formBgImage];
    [self.view addSubview:formBgView];
    
    //帳號欄位底色
    UIImageView *accountBgView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*178, yHeight*504, yWidth*844, yHeight*100)];
    UIImage *accountBgImage = [UIImage imageWithContentsOfFile:
                            [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
    [accountBgView setImage:accountBgImage];
    [self.view addSubview:accountBgView];
    
    //帳號icon
    UIImageView *accountIconView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*202, yHeight*514, yWidth*80, yHeight*80)];
    UIImage *accountIconImage = [UIImage imageWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"icon_account" ofType:@"png"]];
    [accountIconView setImage:accountIconImage];
    [self.view addSubview:accountIconView];
    
    //帳號欄位
    account = [[UITextField alloc]initWithFrame:CGRectMake(yWidth*312, yHeight*504, yWidth*710, yHeight*100)];
    account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入帳號" attributes:@{NSForegroundColorAttributeName: [self colorFromHexString:@"000000"], NSFontAttributeName:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]}];
    [self.view addSubview:account];
    
    //帳號清除欄位資訊按鈕
    UIButton *clearAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearAccountButton.frame = CGRectMake(yWidth*942, yHeight*514, yWidth*80, yHeight*80);
    [clearAccountButton addTarget:self action:@selector(clearAccount:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *clearAccountImage = [UIImage imageWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"icon_clear" ofType:@"png"]];
    [clearAccountButton setImage:clearAccountImage forState:UIControlStateNormal];
    UIImage *clearAccountOverImage = [UIImage imageWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"icon_clear_over" ofType:@"png"]];
    [clearAccountButton setImage:clearAccountOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:clearAccountButton];
    
    //密碼欄位底色
    UIImageView *passwordBgView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*178, yHeight*634, yWidth*844, yHeight*100)];
    UIImage *passwordBgImage = [UIImage imageWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
    [passwordBgView setImage:passwordBgImage];
    [self.view addSubview:passwordBgView];
    
    //密碼icon
    UIImageView *passwordIconView = [[UIImageView alloc] initWithFrame:CGRectMake(yWidth*202, yHeight*644, yWidth*80, yHeight*80)];
    UIImage *passwordIconImage = [UIImage imageWithContentsOfFile:
                                 [[NSBundle mainBundle] pathForResource:@"icon_password" ofType:@"png"]];
    [passwordIconView setImage:passwordIconImage];
    [self.view addSubview:passwordIconView];
    
    //密碼欄位
    password = [[UITextField alloc]initWithFrame:CGRectMake(yWidth*312, yHeight*634, yWidth*710, yHeight*100)];
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入密碼" attributes:@{NSForegroundColorAttributeName: [self colorFromHexString:@"000000"], NSFontAttributeName:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]}];
    [self.view addSubview:password];
    
    //帳號清除欄位資訊按鈕
    UIButton *clearPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearPasswordButton.frame = CGRectMake(yWidth*942, yHeight*644, yWidth*80, yHeight*80);
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
    loginButton.frame = CGRectMake(yWidth*178, yHeight*842, yWidth*844, yHeight*100);
    [self.view addSubview:loginButton];
    
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
    NSString *pRegId = @"";
    
    //MD5
    //NSLog(@"%@", [self md5:pPassword]);
    pPassword = [self md5:self.password.text];
    
    //for test
    pAccount = @"100100362";
    pPassword = @"5a05254570cc97ac9582ad7c5877f1ad";
    pRegId = @"2014144830";
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSLog(@"domain_url>>>>>%@",domainURL);
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@login?account=%@&password=%@&regId=%@&type=IOS"
                           , domainURL, pAccount, pPassword, pRegId];
    
    NSLog(@"urlString>>>>>%@",urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [HTTPResponse statusCode];

    NSLog(@"statusCode>>%d", statusCode);
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] );
    
    NSDictionary *resultJSON;
    if (responseData != nil) {
        resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
        NSString *RETURNCODE = [resultJSON objectForKey:@"RETURNCODE"];
        NSLog(@"%@", RETURNCODE);
        
        if ([@"00" isEqualToString:RETURNCODE]) {
            //登入成功
            
            //紀錄user data
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:pAccount forKey:@"account"];
            [userDefaults setObject:pPassword forKey:@"password"];
            [userDefaults setObject:pRegId forKey:@"regId"];
            [userDefaults synchronize];
//            
            UIViewController *iconViewController = [[IconViewController alloc] init];
            [self presentModalViewController:iconViewController animated:NO];
            
        } else {
        
            
            
        }
    }
    
//    if (true){
//    
//        UIViewController *cont = [[FistViewController alloc] init];
//        self.navigationController.title=@"test";
//        self.navController=[[UINavigationController alloc]initWithRootViewController:cont];
//        [self.view addSubview:self.navController.view];
//    }else{
//        UIAlertView *alertFailed = [[UIAlertView alloc] initWithTitle:@"登入失敗" message:@"登入失敗" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alertFailed show];
//    
//    }
}

- (IBAction)clearAccount:(id)sender {
    [account setText:@""];
}

- (IBAction)clearPassword:(id)sender {
    [password setText:@""];
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
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
@end
