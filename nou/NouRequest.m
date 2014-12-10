//
//  NouRequest.m
//  nou
//
//  Created by focusardi on 2014/12/10.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NouRequest.h"
//@interface NouRequest : NSObject
//- (NSData *)dataObject:(NSString *)urlMethod parameterString:(NSString *)urlPara ;
//@end
@implementation NouRequest

+ (NSData *)urlMethod:(NSString *)urlMethod parameterString:(NSString *)urlPara {
    NSLog(@"NouRequest>>start");
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@%@?%@"
                           , domainURL, urlMethod, urlPara];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSLog(@"NouRequest>>%@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    return responseData;
}

@end