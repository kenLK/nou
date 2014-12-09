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