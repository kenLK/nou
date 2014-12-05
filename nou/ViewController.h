//
//  ViewController.h
//  nou
//
//  Created by Ken on 2014/10/30.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController


@property(nonatomic, retain) IBOutlet UIButton *clickMeButton;
@property (strong, nonatomic) NSArray *detailChildArray;

-(IBAction)clickMeAction:(id)sender;


@end

