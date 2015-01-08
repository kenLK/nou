//
//  IconViewController.m
//  nou
//
//  Created by focusardi on 2014/12/8.
//  Copyright (c) 2014年 Ken. All rights reserved.
//


#import "IconViewController.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
@interface IconViewController ()

@end

@implementation IconViewController
@synthesize navController;

- (void)viewDidAppear:(BOOL)animated {

    //Navigator圖示設定
    //功能title
    UILabel *functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, [Utility appHeight]*174)];
    [functionTitleLabel setText:@"國立空中大學"];
    [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = functionTitleLabel;
    
    self.navigationController.navigationBar.barTintColor = [Utility colorFromHexString:@"34ADDC"];
    self.navigationController.navigationBar.translucent = NO;
    
    //logout
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.frame = CGRectMake([Utility appWidth]*20, [Utility appHeight]*20, [Utility appWidth]*130, [Utility appHeight]*100);
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *logoutImage = [UIImage imageWithContentsOfFile:
                            [[NSBundle mainBundle] pathForResource:@"icon_logout" ofType:@"png"]];
    [logoutButton setBackgroundImage:logoutImage forState:UIControlStateNormal];
    UIImage *logoutOverImage = [UIImage imageWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"icon_logout_over" ofType:@"png"]];
    [logoutButton setBackgroundImage:logoutOverImage forState:UIControlStateHighlighted];
    [logoutButton setTag:99];
    [self.navigationController.navigationBar insertSubview:logoutButton atIndex:99];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;//screenRect.size.height;
    NSLog(@"screenWidth>>>%f", screenWidth);
    NSLog(@"screenHeight>>>%f", screenHeight);
    
    CGFloat yWidth = screenWidth / 1200.0;
    CGFloat yHeight = screenHeight / 1920.0;
    
    //背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, screenRect.size.width, screenRect.size.height)];
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
    
    
 
    
    
    UIImage *btnOverImage = [UIImage imageWithContentsOfFile:
                             [[NSBundle mainBundle] pathForResource:@"btn_over" ofType:@"png"]];
    
    //btn01
    UIButton *btn01 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn01 setTag:1];
    btn01.frame = CGRectMake(yWidth*140, yHeight*310 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn01 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn01Image = [UIImage imageWithContentsOfFile:
                            [[NSBundle mainBundle] pathForResource:@"btn_01" ofType:@"png"]];
    [btn01 setBackgroundImage:btn01Image forState:UIControlStateNormal];
    [btn01 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn01];
    
    UILabel* btn01Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*85, yHeight*500 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn01Label setText:@"最新消息"];
    [btn01Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn01Label.textColor = [UIColor blackColor];
    [btn01Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn01Label];
    
    //btn02
    UIButton *btn02 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn02 setTag:2];
    btn02.frame = CGRectMake(yWidth*505, yHeight*310 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn02 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn02Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_02" ofType:@"png"]];
    [btn02 setBackgroundImage:btn02Image forState:UIControlStateNormal];
    [btn02 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn02];
    
    UILabel* btn02Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*450, yHeight*500 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn02Label setText:@"公布欄"];
    [btn02Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn02Label.textColor = [UIColor blackColor];
    [btn02Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn02Label];
    
    //btn03
    UIButton *btn03 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn03 setTag:3];
    btn03.frame = CGRectMake(yWidth*870, yHeight*310 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn03 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn03Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_03" ofType:@"png"]];
    [btn03 setBackgroundImage:btn03Image forState:UIControlStateNormal];
    [btn03 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn03];
    
    UILabel* btn03Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*815, yHeight*500 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn03Label setText:@"招生資訊"];
    [btn03Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn03Label.textColor = [UIColor blackColor];
    [btn03Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn03Label];

    
    //btn04
    UIButton *btn04 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn04 setTag:4];
    btn04.frame = CGRectMake(yWidth*140, yHeight*675 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn04 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn04Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_04" ofType:@"png"]];
    [btn04 setBackgroundImage:btn04Image forState:UIControlStateNormal];
    [btn04 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn04];
    
    UILabel* btn04Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*85, yHeight*865 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn04Label setText:@"教務系統"];
    [btn04Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn04Label.textColor = [UIColor blackColor];
    [btn04Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn04Label];
    
    //btn05
    UIButton *btn05 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn05 setTag:5];
    btn05.frame = CGRectMake(yWidth*505, yHeight*675 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn05 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn05Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_05" ofType:@"png"]];
    [btn05 setBackgroundImage:btn05Image forState:UIControlStateNormal];
    [btn05 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn05];
    
    UILabel* btn05Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*450, yHeight*865 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn05Label setText:@"聯絡資訊"];
    [btn05Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn05Label.textColor = [UIColor blackColor];
    [btn05Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn05Label];
    
    //btn06
    UIButton *btn06 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn06 setTag:6];
    btn06.frame = CGRectMake(yWidth*870, yHeight*675 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn06 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn06Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_06" ofType:@"png"]];
    [btn06 setBackgroundImage:btn06Image forState:UIControlStateNormal];
    [btn06 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn06];
    
    UILabel* btn06Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*815, yHeight*865 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn06Label setText:@"行事曆"];
    [btn06Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn06Label.textColor = [UIColor blackColor];
    [btn06Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn06Label];
    
    //btn07
    UIButton *btn07 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn07 setTag:7];
    btn07.frame = CGRectMake(yWidth*140, yHeight*1040 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn07 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn07Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_07" ofType:@"png"]];
    [btn07 setBackgroundImage:btn07Image forState:UIControlStateNormal];
    [btn07 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn07];
    
    UILabel* btn07Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*85, yHeight*1230 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn07Label setText:@"交通資訊"];
    [btn07Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn07Label.textColor = [UIColor blackColor];
    [btn07Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn07Label];
    
    //btn08
    UIButton *btn08 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn08 setTag:8];
    btn08.frame = CGRectMake(yWidth*505, yHeight*1040 + [Utility appModHeight], yWidth*190, yHeight*190);
    [btn08 addTarget:self action:@selector(functionView:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btn08Image = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"btn_08" ofType:@"png"]];
    [btn08 setBackgroundImage:btn08Image forState:UIControlStateNormal];
    [btn08 setImage:btnOverImage forState:UIControlStateHighlighted];
    [self.view addSubview:btn08];
    
    UILabel* btn08Label = [[UILabel alloc] initWithFrame:CGRectMake(yWidth*450, yHeight*1230 + [Utility appModHeight], yWidth*300, yHeight*60)];
    [btn08Label setText:@"校園地圖"];
    [btn08Label setFont:[UIFont fontWithName:@"微軟正黑體" size:yHeight*50]];
    btn08Label.textColor = [UIColor blackColor];
    [btn08Label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:btn08Label];
    
    
    
}

- (IBAction)logout:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登出"
                                                    message:@"確定登出?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //cancel logout
            break;
        case 1: //"Yes" pressed
            //process logout
            [Utility logout];
            UIViewController *loginViewController = [[LoginViewController alloc] init];
            [self presentModalViewController:loginViewController animated:NO];
            break;
    }
}


- (IBAction)functionView:(UIButton *)sender {
    NSLog(@"funcitonView~~");
    
    NSArray *destUrl = [NSArray arrayWithObjects:
               @"",
               @"news_index",
               @"bulletin_index",
               @"recruit_index",
               @"index",
               @"contact_index",
               @"calendar_index",
               @"roadmap_index",
               @"schoolmap_index",
               nil];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    
    menuViewController.url = [destUrl objectAtIndex: sender.tag];
//    if (sender.tag == 4) {
//        menuViewController.isIndex = YES;
//    }

    [self.navigationController pushViewController:menuViewController animated:YES];
    
}


@end

