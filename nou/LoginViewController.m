//
//  LoginViewController.m
//  nou
//
//  Created by Ken on 2014/11/3.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "LoginViewController.h"
#import "FistViewController.h"
@interface LoginViewController ()


@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIAlertView *alertProcess;

@end

@implementation LoginViewController
@synthesize account,password,alert,alertProcess;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    if (true){
        NSLog(@"123");
    }
    NSLog(@"account>>>>%@<<<<",self.account.text);
    if (true){
        NSLog(@"123");
    }
    
//    if ([self.account.text isEqual:@"130100325"] && [self.password.text isEqual:@"12345678"]) {
    if (true){
    
        UIViewController *cont = [[FistViewController alloc] init];
        self.navigationController.title=@"test";
        self.navController=[[UINavigationController alloc]initWithRootViewController:cont];
        [self.view addSubview:self.navController.view];
    }else{
        UIAlertView *alertFailed = [[UIAlertView alloc] initWithTitle:@"登入失敗" message:@"登入失敗" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertFailed show];
    
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
@end
