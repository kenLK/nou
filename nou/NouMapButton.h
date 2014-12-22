//
//  NouMapButton.h
//  nou
//
//  Created by focusardi on 2014/12/18.
//  Copyright (c) 2014年 Ken. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RADataObject.h"
@interface NouMapButton : UIButton {
    id userData;
}

@property (nonatomic, readwrite, retain) id userData;
@property (nonatomic, readwrite, retain) RADataObject *dataObj;
@end