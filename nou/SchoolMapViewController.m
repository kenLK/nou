//
//  SchoolMapViewController.m
//  nou
//
//  Created by focusardi on 2014/12/9.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "SchoolMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface SchoolMapViewController ()

@end

@implementation SchoolMapViewController
GMSMapView *mapView_;

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stno = [userDefaults stringForKey:@"account"];
    NSString *VALID_STR = [userDefaults stringForKey:@"VALID_STR"];
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"stno=%@&VALID_STR=%@"
                           ,stno, VALID_STR];
    
    NSLog(@"urlString>>>>>%@",urlString);
    
    NSData *responseData = [NouRequest urlMethod:@"schoolmap_index" parameterString:urlString];
    
    //權限錯誤的RETURNCODE為-997，尚未實作
    NSDictionary *resultJSON;
    if (responseData != nil) {
        resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        NSDictionary *HEADER = [resultJSON objectForKey:@"HEADER"];
        
        NSArray *menuArray = [resultJSON objectForKey:@"MENU"];
        
        for (int i = 0;i < menuArray.count;i++) {
            NSDictionary *menuDic = menuArray[i];
            NSArray *detailArray = [menuDic objectForKey:@"DETAIL"];
            
            NSDictionary *detailDic = detailArray[0];
            
            NSArray *multiAddrArray = [detailDic objectForKey:@"MULTIADDR"];
            
            NSLog(@"i>>%d", i);
            if (multiAddrArray != nil) {
                NSString *GOOGLE_MAP = [detailDic objectForKey:@"GOOGLE_MAP"];
                NSArray *MULTISNIPPET = [detailDic objectForKey:@"MULTISNIPPET"];
                NSArray *MULTITITLE = [detailDic objectForKey:@"MULTITITLE"];
                
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
                CGFloat screenHeight = screenRect.size.height;
                CGFloat yWidth = screenWidth / 1200.0;
                CGFloat yHeight = screenHeight / 1920.0;
                
                
                
                
                
                //UIEdgeInsets mapInsets = UIEdgeInsetsMake(yWidth*78, yHeight*300, yWidth*1044, yHeight*600);
                UIEdgeInsets mapInsets = UIEdgeInsetsMake(100.0, 0.0, 0.0, 300.0);
                //GMSMapView *mapView_;
                mapView_.padding = mapInsets;
                
                
                
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                                        longitude:151.20
                                                                             zoom:6];
                //mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
                mapView_.myLocationEnabled = YES;
                self.view = mapView_;
                
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
                marker.title = @"Sydney";
                marker.snippet = @"Australia";
                marker.map = mapView_;
                
            }

            
        
        }
        
        
    }
    
}

@end