//
//  IconViewController.h
//  nou
//
//  Created by focusardi on 2014/12/8.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface IconViewController : UIViewController

@property(nonatomic, retain) UINavigationController *navController;


@property (strong, nonatomic) IBOutlet UIButton *btn01;
@property (strong, nonatomic) IBOutlet UIButton *btn02;
@property (strong, nonatomic) IBOutlet UIButton *btn03;
@property (strong, nonatomic) IBOutlet UIButton *btn04;
@property (strong, nonatomic) IBOutlet UIButton *btn05;
@property (strong, nonatomic) IBOutlet UIButton *btn06;
@property (strong, nonatomic) IBOutlet UIButton *btn07;
@property (strong, nonatomic) IBOutlet UIButton *btn08;
@property BOOL isClicked;//已經按了?

@end

