//
//  MenuViewController.h
//  nou
//
//  Created by focusardi on 2014/12/15.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utility.h"
#import "NouRequest.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "LoginViewController.h"
#import "IconViewController.h"
#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#import <QuartzCore/QuartzCore.h>

@interface MenuViewController : UIViewController

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7_0 @"7.0"

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIImageView *footerImageView;
@property CGFloat subjectHeight;
@property BOOL isIndex;//是否為教務系統
@property BOOL isClicked;//已經按了?
@property BOOL isNotification;//是否由推播進入?
@property BOOL isNoNeedReload;
@end
