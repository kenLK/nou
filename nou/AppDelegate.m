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
#import "FistViewController.h"
#import "LoginViewController.h"
#import "IconViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyA_uiLkxxhoSRfcHN6znkMoyJQyIBIWeLs"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
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
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pAccount = @"";
    NSString *pPassword = @"";
    NSString *pRegId = @"";
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@reg?regId=%@&type=IOS"
                           , domainURL, pRegId];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
    pAccount = [userDefaults stringForKey:@"account"];
    pPassword = [userDefaults stringForKey:@"password"];
    pRegId = [userDefaults stringForKey:@"regId"];
    
    NSLog(@"pAccount>>>%@", pAccount);
        
        if (![@"" isEqualToString:pAccount]) {
            UIViewController *iconViewController = [[IconViewController alloc] init];
            //[self presentModalViewController:iconViewController animated:NO];
            [self.window setRootViewController:iconViewController];
            
            [self.window makeKeyAndVisible];
            return YES;
        }
    
    
//    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS8
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
    
    
    
    LoginViewController *loginView = [[LoginViewController alloc] init];

    [self.window setRootViewController:loginView];
    
    [self.window makeKeyAndVisible];
    
    
    //    [self.window setRootViewController:self.navController];
    
    //    [self.window makeKeyAndVisible];
    
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError: (NSError *)err {
    //錯誤處理...
    NSLog(@"err>>%@",err);
}
@end
