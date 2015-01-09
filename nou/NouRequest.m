//
//  NouRequest.m
//  nou
//
//  Created by focusardi on 2014/12/10.
//  Copyright (c) 2014年 Ken. All rights reserved.
//


#import "NouRequest.h"


@interface NouRequest ()
@property(readwrite) BOOL isRetry;
@end

@implementation NouRequest
@synthesize isRetry;

+ (NSData *)urlMethod:(NSString *)urlMethod parameterString:(NSString *)urlPara {
    NSLog(@"NouRequest urlMethod>>start");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regId = [userDefaults stringForKey:@"regId"];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@%@?%@&token=%@"
                           , domainURL, urlMethod, urlPara, regId];
    NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"NouRequest>>%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
//    if (error != nil) {
//        NSLog(@"request error!");
//        
//        return [self urlMethod:urlMethod parameterString:urlPara];
//    }
    
    return responseData;
}
+ (NSData *)urlAll:(NSString *)urlAll {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regId = [userDefaults stringForKey:@"regId"];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@%@&token=%@"
                           , domainURL, urlAll, regId];
    NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"NouRequest urlAll>>%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
//    if (error != nil) {
//        NSLog(@"request error!");
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"網路錯誤"
//                                                        message:@"確定重新讀取?"
//                                                       delegate:self
//                                              cancelButtonTitle:@"No"
//                                              otherButtonTitles:@"Yes", nil];
//        [alert show];
//        
//        
//        return [self urlAll:urlAll];
//    }
    
    return responseData;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //cancel
            isRetry = NO;
            break;
        case 1: //"Yes" pressed
            //process
            isRetry = YES;
            break;
    }
}

@end