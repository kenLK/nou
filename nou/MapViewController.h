//
//  MapViewController.h
//  nou
//
//  Created by focusardi on 2014/12/18.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utility.h"
#import "NouRequest.h"
#import "RADataObject.h"
#import "LoginViewController.h"
#import "IconViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController

@property (strong, nonatomic) RADataObject *dataObj;
@property float sumLong;
@property float sumLat;
@property int sumMarkers;
@end
