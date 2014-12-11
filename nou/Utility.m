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
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat modHeight = screenRect.size.height - appRect.size.height;
    return modHeight;
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
        NSLog (@"Match ? not found");
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
@end