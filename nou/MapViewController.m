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
-(void)viewDidAppear:(BOOL)animated {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIImageView *backgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *backgImage = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"bg_V" ofType:@"jpg"]];
    [backgImageView setImage:backgImage];
    [self.view addSubview:backgImageView];
    
    if ((![dataObj.googleMap isEqualToString:@""])) {
        //有google map
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:23.4857501
                                                                longitude:120.0843006
                                                                     zoom:[dataObj.zoom intValue]];
        mapView_ = [GMSMapView mapWithFrame:CGRectMake([Utility appWidth]*0.0, 0, [Utility appWidth]*1200, [Utility appHeight]*1800) camera:camera];
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
                                 [mapView_ setCamera:[GMSCameraPosition cameraWithLatitude:aPlacemark.location.coordinate.latitude
                                                                               longitude:aPlacemark.location.coordinate.longitude
                                                                                    zoom:[dataObj.zoom intValue]]];
                             }
                         }];
            
        }

    }
    
    //Navigator圖示設定
    
    //移除登出按鈕99, 教務系統按鈕98
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if(view.tag == 99 || view.tag == 98)
        {
            [view removeFromSuperview];
        }
    }
    
    self.navigationController.navigationBar.barTintColor = [Utility colorFromHexString:@"34ADDC"];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)goHome:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *iconViewController = [[IconViewController alloc] init];
    [self presentModalViewController:iconViewController animated:NO];
}
@end
