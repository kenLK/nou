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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@schoolmap_index?stno=%@&VALID_STR=%@"
                           , domainURL, stno, VALID_STR];
    
    NSLog(@"urlString>>>>>%@",urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    //NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    //NSInteger statusCode = [HTTPResponse statusCode];
    
    
    //權限錯誤的RETURNCODE為-997，尚未實作
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    
    
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}

@end