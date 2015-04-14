//
//  Utility.m
//  nou
//
//  Created by focusardi on 2014/12/10.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+(UIColor *) colorFromHexString:(NSString *)hexString {
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

+(CGFloat) appWidth {
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat appWidth = appRect.size.width;
    CGFloat yWidth = appWidth / 1200.0;
    return yWidth;
}
+(CGFloat) appHeight {
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat appHeight = appRect.size.height;
    CGFloat yHeight = appHeight / 1920.0;
    return yHeight;
}
+(CGFloat) appModHeight {
//    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat modHeight = screenRect.size.height - appRect.size.height;
//    
    return -40;
}

+(CGFloat) boundWidth {
    CGRect appRect = [[UIScreen mainScreen] bounds];
    CGFloat appWidth = appRect.size.width;
    CGFloat yWidth = appWidth / 1200.0;
    return yWidth;
}
+(CGFloat) boundHeight {
    CGRect appRect = [[UIScreen mainScreen] bounds];
    CGFloat appHeight = appRect.size.height;
    CGFloat yHeight = appHeight / 1920.0;
    return yHeight;
}



+(NSString *) setUrlWithMap:(NSString *) url parameterMap:(NSMutableDictionary *) map autoValid:(BOOL) autoValid {
    NSMutableString *para = [[NSMutableString alloc]initWithString:@""];
    NSArray *key = map.allKeys;
    
    for (int i = 0;i < key.count;i++) {
        [para appendString:@"&"];
        [para appendString:key[i]];
        [para appendString:@"="];
        [para appendString:map[key[i]]];
    }
    return [self setUrlWithString:url parameterMap:para autoValid:autoValid];
}
+(NSString *) setUrlWithString:(NSString *) url parameterMap:(NSString *) para autoValid:(BOOL) autoValid {
    NSMutableString *returnUrl = [[NSMutableString alloc]initWithString:@""];

    [returnUrl appendString:url];
    
    NSRange match = [url rangeOfString:@"?"];
    
    if (match.location == NSNotFound) {
        [returnUrl appendString:@"?"];
    }
    
    if (YES == autoValid) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *stno = [userDefaults stringForKey:@"account"];
        NSString *VALID_STR = [userDefaults stringForKey:@"VALID_STR"];
        NSString *ACCOUNT = [userDefaults stringForKey:@"account"];
        [returnUrl appendFormat:@"&stno=%@", stno];
        [returnUrl appendFormat:@"&VALID_STR=%@", VALID_STR];
        [returnUrl appendFormat:@"&ACCOUNT=%@", ACCOUNT];
    }
    
    [returnUrl appendString:para];
    
    return returnUrl;
}
+(NSString*) checkNull:(NSString *)str {
    
    if ([str isKindOfClass:[NSString class]] && [str length] > 0) {
        return str;
    }
    else {
        return @"";
    }
}
+(NSString*) checkNull:(NSString *)str defaultString:(NSString *)defaultString {
    
    if ([str isKindOfClass:[NSString class]] && [str length] > 0) {
        return str;
    }
    else {
        return defaultString;
    }
}
+(NSArray *) stringToArray:(NSString *) input {
    //parse json傳來的string轉array
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"[ \"] "];
    NSArray *nameArray = [[[input componentsSeparatedByCharactersInSet:charSet]
                           componentsJoinedByString:@""]
                          componentsSeparatedByString:@","];

    return nameArray;
}

+(NSTextAlignment) alignTextToNSTextAlignment:(NSString *) alignText {
    //parse json傳來的align
    
    if ([@"RIGHT"isEqualToString:alignText]) {
        return (NSTextAlignment)NSTextAlignmentRight;
    } else if ([@"LEFT"isEqualToString:alignText]) {
        return (NSTextAlignment)NSTextAlignmentLeft;
    } else {
        return (NSTextAlignment)NSTextAlignmentCenter;
    }
}
+(BOOL) ynToBool:(NSString *) input {
    //Y或N to YES或NO
    if (input == nil) {
        return NO;
    }
    
    if ([@"Y" isEqualToString:input]) {
        return YES;
    } else {
        return NO;
    }
}
+(NSString *) stringEncode:(NSString *) input {
    NSString *escapedString = [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return escapedString;
}
+(void) logout {
    NSLog(@"logout!!!!");
    //登出
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *pAccount = @"";
    NSString *pPassword = @"";
    NSString *pRegId = @"";
    
    pAccount = [userDefaults stringForKey:@"account"];
    pPassword = [userDefaults stringForKey:@"password"];
    pRegId = [userDefaults stringForKey:@"regId"];
    NSLog(@"NSUserDefaults>>%@", pAccount);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSLog(@"domain_url>>>>>%@",domainURL);
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@logout?account=%@&password=%@&regId=%@&type=IOS"
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
            //登出成功
            
        } else {
        }
    }
    //消除紀錄user data
    [userDefaults setObject:@"" forKey:@"account"];
    [userDefaults setObject:@"" forKey:@"password"];
    [userDefaults synchronize];

}

+(NSString *) versionString {

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
    //NSNumber *buildNumber = [infoDict objectForKey:@"CFBundleVersion"]; // example: 42
    
    return [[NSString alloc] initWithFormat:@"v%@", appVersion];
    
}
@end
