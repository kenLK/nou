//
//  NouRequest.h
//  nou
//
//  Created by focusardi on 2014/12/10.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NouRequest : NSObject
//@property (strong, nonatomic) NSString *HTTPMethod;
+ (NSData *)urlMethod:(NSString *)urlMethod parameterString:(NSString *)urlPara ;
@end