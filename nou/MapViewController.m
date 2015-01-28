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
        mapView_ = [GMSMapView mapWithFrame:CGRectMake([Utility appWidth]*0.0, 0, [Utility appWidth]*1200, screenRect.size.height) camera:camera];
        mapView_.myLocationEnabled = YES;
        mapView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:mapView_];
        
        //marker
        
        //是否有多重marker
        if (dataObj.multiAddr != nil) {
            
            //有無經緯度
            if (dataObj.multiLocation.count > 0) {
                for (int i = 0;i < dataObj.multiLocation.count;i++) {
                    NSString *location = [dataObj.multiLocation objectAtIndex:i];
                    NSArray *positions = [location componentsSeparatedByString:@","];
                    
                    if (positions.count == 2) {
                        NSString *latitude = [positions objectAtIndex:0];
                        NSString *longitude = [positions objectAtIndex:1];
                        
                        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                        
                        GMSMarker *marker = [GMSMarker markerWithPosition:position];
                        marker.title = dataObj.googleMap;
                        marker.snippet = dataObj.name;
                        marker.map = mapView_;
                        [mapView_ setCamera:[GMSCameraPosition cameraWithLatitude:[latitude doubleValue]
                                                                        longitude:[longitude doubleValue]
                                                                             zoom:[dataObj.zoom intValue]]];
                    } else {
                        [self setMarkerByAddr:[dataObj.multiAddr objectAtIndex:i]];
                    }
                }
                
                
            } else {
                for (int i = 0;i < dataObj.multiAddr.count;i++) {
                    
                    [self setMarkerByAddr:[dataObj.multiAddr objectAtIndex:i]];

                }
            }
            
            
            
            
        } else {
            //單一marker
            //有無經緯度
            if (![@"" isEqualToString:dataObj.location]) {
                NSArray *positions = [dataObj.location componentsSeparatedByString:@","];
                
                if (positions.count == 2) {
                    NSString *latitude = [positions objectAtIndex:0];
                    NSString *longitude = [positions objectAtIndex:1];
                    
                    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                    
                    GMSMarker *marker = [GMSMarker markerWithPosition:position];
                    marker.title = dataObj.googleMap;
                    marker.snippet = dataObj.name;
                    marker.map = mapView_;
                    [mapView_ setCamera:[GMSCameraPosition cameraWithLatitude:[latitude doubleValue]
                                                                    longitude:[longitude doubleValue]
                                                                         zoom:[dataObj.zoom intValue]]];
                } else {
                    [self setMarkerByAddr:dataObj.googleMap];
                }
                
                
            } else {
                [self setMarkerByAddr:dataObj.googleMap];

            }
            
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
    
    //顯示客制回上一頁按紐
    self.navigationItem.hidesBackButton = YES;
    UIButton *backBtn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]];
    [backBtn0 setBackgroundImage:backBtnImage0 forState:UIControlStateNormal];
    [backBtn0 addTarget:self action:@selector(toLastPage) forControlEvents:UIControlEventTouchUpInside];
    backBtn0.frame = CGRectMake(0, 0, [Utility appWidth]*130, [Utility appHeight]*100);
    UIBarButtonItem *backButton0 = [[UIBarButtonItem alloc] initWithCustomView:backBtn0] ;
    self.navigationItem.leftBarButtonItem = backButton0;
    
}

- (void) toLastPage {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) setMarkerByAddr:(NSString *)addr {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addr
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
@end
