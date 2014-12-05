//
//  LoginViewController.h
//  nou
//
//  Created by Ken on 2014/11/3.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic, retain) UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end
