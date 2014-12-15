//
//  Utility.h
//  nou
//
//  Created by focusardi on 2014/12/10.
//  Copyright (c) 2014年 Ken. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "NouRequest.h"
#import <GoogleMaps/GoogleMaps.h>


@interface Utility : NSObject
//@property (strong, nonatomic) NSString *HTTPMethod;

//MD5編碼
+(NSString *)md5:(NSString *) input;

//FFFFFF轉成UIColor
+(UIColor *) colorFromHexString:(NSString *)hexString;

+(CGFloat) appWidth;
+(CGFloat) appHeight;
+(CGFloat) appModHeight;

+(CGFloat) boundWidth;
+(CGFloat) boundHeight;


+(NSString *) setUrlWithMap:(NSString *) url parameterMap:(NSMutableDictionary *) map autoValid:(BOOL) autoValid ;
+(NSString *) setUrlWithString:(NSString *) url parameterMap:(NSString *) para autoValid:(BOOL) autoValid ;
+(NSString*) checkNull:(NSString *)str ;
@end