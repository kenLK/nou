//
//  AppDelegate.m
//  nou
//
//  Created by Ken on 2014/10/30.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ViewController.h"
#import "LoginViewController.h"
#import "IconViewController.h"
#import "MenuViewController.h"
#import "NouRequest.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //google map api key
    [GMSServices provideAPIKey:@"AIzaSyDprzva29xoGaSCaMG5tzrffY8j9zm8eqY"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //Accept push notification when app is not open
    if (remoteNotif) {
        [self handleRemoteNotification:application userInfo:remoteNotif from:@"launch"];
        return YES;
    }
    
    
    
    
//    UIViewController *cont=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
//    UIViewController *cont = [[ViewController alloc] init];
    
    
    
//    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//    #ifdef __IPHONE_8_0
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
//                                                                                             |UIRemoteNotificationTypeSound
//                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
//        [application registerUserNotificationSettings:settings];
//    #endif
//    } else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:myTypes];
//    }
    
    
    
    //iOS8 取得推播token
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert)
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        //iOS7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                         |UIRemoteNotificationTypeSound
                                                         |UIRemoteNotificationTypeAlert)];
    }
    
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageWithContentsOfFile:
//                                                         [[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageWithContentsOfFile:
//                                                                       [[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]]];
    
    // 先確定是否已有帳號密碼，若是正確的則直接登入
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pAccount = @"";
    NSString *pPassword = @"";
    NSString *pRegId = @"";
    
    pAccount = [userDefaults stringForKey:@"account"];
    pPassword = [userDefaults stringForKey:@"password"];
    pRegId = [userDefaults stringForKey:@"regId"];
    
    if (![@"" isEqualToString:pAccount]) {
        NSString* urlString = [[NSString alloc] initWithFormat:@"account=%@&password=%@&regId=%@&type=IOS"
                               , pAccount, pPassword, pRegId];
        NSData *responseData =  [NouRequest urlMethod:@"login" parameterString:urlString];
        NSDictionary *resultJSON;
        if (responseData != nil) {
            resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            
            NSString *RETURNCODE = [resultJSON objectForKey:@"RETURNCODE"];
            NSLog(@"login code>>%@", RETURNCODE);
            
            if ([@"00" isEqualToString:RETURNCODE]) {
                //登入成功
                //紀錄user data
                [userDefaults setObject:pAccount forKey:@"account"];
                [userDefaults setObject:pPassword forKey:@"password"];
                [userDefaults setObject:[resultJSON objectForKey:@"PW"] forKey:@"VALID_STR"];
                [userDefaults synchronize];
                
                UIViewController *iconViewController = [[IconViewController alloc] init];

                self.navController = [[UINavigationController alloc] initWithRootViewController:iconViewController];
                
                [self.window setRootViewController:self.navController];
                
                
                [self.window makeKeyAndVisible];
                return YES;
            }
        }
    }

    
    LoginViewController *root = [[LoginViewController alloc]init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:root];
    [self.window setRootViewController:self.navController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //確認是否在root頁
    if (self.navController != nil && self.navController.viewControllers.count == 1) {
        // 先確定是否已有帳號密碼，若是正確的則直接登入
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *pAccount = @"";
        NSString *pPassword = @"";
        NSString *pRegId = @"";
        
        pAccount = [userDefaults stringForKey:@"account"];
        pPassword = [userDefaults stringForKey:@"password"];
        pRegId = [userDefaults stringForKey:@"regId"];
        
        if (![@"" isEqualToString:pAccount]) {
            NSString* urlString = [[NSString alloc] initWithFormat:@"account=%@&password=%@&regId=%@&type=IOS"
                                   , pAccount, pPassword, pRegId];
            NSData *responseData =  [NouRequest urlMethod:@"login" parameterString:urlString];
            NSDictionary *resultJSON;
            if (responseData != nil) {
                resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                
                NSString *RETURNCODE = [resultJSON objectForKey:@"RETURNCODE"];
                NSLog(@"login code>>%@", RETURNCODE);
                
                if ([@"00" isEqualToString:RETURNCODE]) {
                    //登入成功
                    //紀錄user data
                    [userDefaults setObject:pAccount forKey:@"account"];
                    [userDefaults setObject:pPassword forKey:@"password"];
                    [userDefaults setObject:[resultJSON objectForKey:@"PW"] forKey:@"VALID_STR"];
                    [userDefaults synchronize];
                    
                    UIViewController *iconViewController = [[IconViewController alloc] init];
                    if (self.navController != nil) {
                        [self.navController setViewControllers:[NSArray arrayWithObject:iconViewController] animated:YES];
                    } else {
                        self.navController = [[UINavigationController alloc] initWithRootViewController:iconViewController];
                    }
                    
                    //[self.window setRootViewController:self.navController];
                    
                    [self.window makeKeyAndVisible];
                    return;
                    
                }
            }
        }
        
        
        LoginViewController *root = [[LoginViewController alloc]init];
        if (self.navController != nil) {
            [self.navController setViewControllers:[NSArray arrayWithObject:root] animated:YES];
        } else {
            self.navController = [[UINavigationController alloc] initWithRootViewController:root];
        }
        
        [self.window makeKeyAndVisible];
        
        return;

    
    }
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)deviceToken
{
    //將Device Token由NSData轉換為字串
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *iOSDeviceToken =
    [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
     ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
     ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
     ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"devicetoken>>%@",iOSDeviceToken);
    //將Device Token傳給Provider...
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"regId=%@&type=IOS", iOSDeviceToken];
    
    //寫入regId
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:iOSDeviceToken forKey:@"regId"];
    [userDefaults synchronize];
    
    [NouRequest urlMethod:@"reg" parameterString:urlString];
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError: (NSError *)err {
    //錯誤處理...
    NSLog(@"err>>%@",err);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [self handleRemoteNotification:application userInfo:userInfo from:@"receive"];
 
}
-(void)handleRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo from:(NSString *)from  {
    //點選推播訊息後
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *TARGET_TP = [userInfo objectForKey:@"TARGET_TP"];
    NSString *SEQ = [[NSString alloc] initWithFormat:@"&seq=%@", [userInfo objectForKey:@"SEQ"]];
    
    NSString *alertMsg = @"";
    NSInteger badge = 0;
    
//    if( [apsInfo objectForKey:@"alert"] != NULL)
//    {
//        alertMsg = [apsInfo objectForKey:@"alert"];
//    }
//    
//
    if ( application.applicationState == UIApplicationStateActive ) {
        if( [apsInfo objectForKey:@"badge"] != NULL)
        {
            badge = [[apsInfo objectForKey:@"badge"] integerValue];
        }
        if(badge>=0)
        {
            // reset badge counter.
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
//        int currentBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
//        currentBadgeNumber += 1;
//        [UIApplication sharedApplication].applicationIconBadgeNumber = currentBadgeNumber;
    } else {
        //點選推播後
        
        int currentBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
        currentBadgeNumber += -1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = currentBadgeNumber;
        
        NSString *url = @"";
        
        if ([@"01" isEqualToString:TARGET_TP]) {
            url = @"news_detail";
        } else if ([@"02" isEqualToString:TARGET_TP]) {
            url = @"bulletin_detail";
        } else if ([@"03" isEqualToString:TARGET_TP]) {
            url = @"bulletin_detail";
        } else if ([@"04" isEqualToString:TARGET_TP]) {
            url = @"bulletin_detail";
        } else if ([@"05" isEqualToString:TARGET_TP]) {
            url = @"bulletin_detail";
        } else if ([@"06" isEqualToString:TARGET_TP]) {
            url = @"recruit_detail";
        } else if ([@"07" isEqualToString:TARGET_TP]) {
            url = @"calendar_index";
        } else {
            return;
        }
        MenuViewController *menuViewController = [[MenuViewController alloc] init];
        
        menuViewController.url = [Utility setUrlWithString:url parameterMap:SEQ autoValid:YES];
        [menuViewController setIsNotification:YES];
        
        if (self.navController == nil) {
            self.navController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
            [self.navController.navigationBar setBackgroundColor:[Utility colorFromHexString:@"34ADDC"]];
            [self.window setRootViewController:navController];
            [self.window makeKeyAndVisible];
        } else {
            [self.navController.navigationBar setBackgroundColor:[Utility colorFromHexString:@"34ADDC"]];
            [self.navController setViewControllers:[NSArray arrayWithObject:menuViewController] animated:YES];
            [self.window makeKeyAndVisible];
        }        

    }
    
}
@end
