//
//  MapViewController.m
//  nou
//
//  Created by focusardi on 2014/12/18.
//  Copyright (c) 2014年 Ken. All rights reserved.
//


#import "MapViewController.h"

@interface MapViewController ()<GMSMapViewDelegate>

@end


@implementation MapViewController {
    GMSMapView *mapView_;
}

@synthesize dataObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIImageView *backgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *backgImage = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"bg_V" ofType:@"jpg"]];
    [backgImageView setImage:backgImage];
    [self.view addSubview:backgImageView];
    
    //Navigator圖示設定
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_menu" ofType:@"png"]];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, [Utility appWidth]*130, [Utility appHeight]*100);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.rightBarButtonItem = backButton;
    
    UIImage *backImage = [UIImage imageWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:@"alpha_header_bg" ofType:@"png"]];
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    
    
    if ((![dataObj.googleMap isEqualToString:@""])) {
        //有google map
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:23.4857501
                                                                longitude:120.0843006
                                                                     zoom:[dataObj.zoom intValue]];
        mapView_ = [GMSMapView mapWithFrame:CGRectMake([Utility appWidth]*0.0, 20 + self.navigationController.navigationBar.frame.size.height, [Utility appWidth]*1200, [Utility appHeight]*1800) camera:camera];
        mapView_.myLocationEnabled = YES;
        mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:mapView_];
        
        //marker
        
        //是否有多重marker
        if (dataObj.multiAddr != nil) {
            for (int i = 0;i < dataObj.multiAddr.count;i++) {
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder geocodeAddressString:[dataObj.multiAddr objectAtIndex:i]
                             completionHandler:^(NSArray* placemarks, NSError* error){
                                 for (CLPlacemark* aPlacemark in placemarks)
                                 {
                                     //https://developers.google.com/maps/documentation/ios/start
                                     // Process the placemark.
                                     GMSMarker *marker = [GMSMarker markerWithPosition:(aPlacemark.location.coordinate)];
                                     marker.title = [dataObj.multiTitle objectAtIndex:i];
                                     marker.snippet = [dataObj.multiSnippet objectAtIndex:i];
                                     marker.map = mapView_;
                                 }
                             }];
            }
            
        } else {
            //單一marker
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:dataObj.googleMap
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             for (CLPlacemark* aPlacemark in placemarks)
                             {
                                 //https://developers.google.com/maps/documentation/ios/start
                                 // Process the placemark.
                                 GMSMarker *marker = [GMSMarker markerWithPosition:(aPlacemark.location.coordinate)];
                                 marker.title = dataObj.googleMap;
                                 marker.snippet = dataObj.name;
                                 marker.map = mapView_;
                                 mapView_.camera = [GMSCameraPosition cameraWithLatitude:aPlacemark.location.coordinate.latitude
                                                                               longitude:aPlacemark.location.coordinate.longitude
                                                                                    zoom:[dataObj.zoom intValue]];
                             }
                         }];
            
        }

    }
    
}

-(void)goHome:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *iconViewController = [[IconViewController alloc] init];
    [self presentModalViewController:iconViewController animated:NO];
}
@end
