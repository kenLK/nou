//
//  NouNavBar.m
//  nou
//
//  Created by focusardi on 2014/12/11.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NouNavBar.h"
//static CGFloat const CustomNavigationBarHeight = 92;
//static CGFloat const NavigationBarHeight = 44;
//static CGFloat const CustomNavigationBarHeightDelta = CustomNavigationBarHeight - NavigationBarHeight;

@implementation NouNavBar
@synthesize titleName,functionTitleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //      UIColor *titleColor = [[HITheme currentTheme] fontColorForLabelForLocation:HIThemeLabelNavigationTitle];
        //      UIFont *titleFont = [[HITheme currentTheme] fontForLabelForLocation:HIThemeLabelNavigationTitle];
        
        //      [self setTitleTextAttributes:@{ UITextAttributeFont : titleFont, UITextAttributeTextColor : titleColor }];
        
        //CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -CustomNavigationBarHeightDelta / 2.0);
        //self.transform = translate;
        [self resetBackgroundImageFrame];
        
    }
    return self;
}

- (void)resetBackgroundImageFrame
{
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString:@"BarBackground"].length != 0) {
            //NSLog(@"nav>%f",self.bounds.size.height);
            view.frame = CGRectMake(0, 0 + [Utility appModHeight], self.bounds.size.width, self.bounds.size.height);
            
            
            //背景
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0 + [Utility appModHeight], [Utility appWidth]*1200, [Utility appHeight]*174)];
            UIImage *image = [UIImage imageWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"alpha_header_bg" ofType:@"png"]];
            [imageView setImage:image];
            [view addSubview:imageView];
            
            //標題
            functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0 + [Utility appModHeight], [Utility appWidth]*1200, [Utility appHeight]*174)];
            NSLog(@"nav title>>%@", titleName);
            if (titleName == nil) {
                [functionTitleLabel setText:@"校務資訊系統"];
            } else {
                [functionTitleLabel setText:titleName];
            }
            
            [functionTitleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*60]];
            functionTitleLabel.textColor = [UIColor whiteColor];
            [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:functionTitleLabel];
            
            //回icon
            UIButton *btn07 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn07.frame = CGRectMake([Utility appWidth]*1034, [Utility appHeight]*37 + [Utility appModHeight], [Utility appWidth]*130, [Utility appHeight]*100);
            [btn07 addTarget:self action:@selector(iconView:) forControlEvents:UIControlEventTouchUpInside];
            UIImage *btn07Image = [UIImage imageWithContentsOfFile:
                                   [[NSBundle mainBundle] pathForResource:@"icon_menu" ofType:@"png"]];
            [btn07 setBackgroundImage:btn07Image forState:UIControlStateNormal];
            [view addSubview:btn07];
            
            
//            UIImageView *imageIconView = [[UIImageView alloc] initWithFrame:CGRectMake([Utility appWidth]*1034, [Utility appHeight]*37 + [Utility appModHeight], [Utility appWidth]*130, [Utility appHeight]*100)];
//            UIImage *imageIcon = [UIImage imageWithContentsOfFile:
//                              [[NSBundle mainBundle] pathForResource:@"icon_menu" ofType:@"png"]];
//            [imageIconView setImage:imageIcon];
//            [view addSubview:imageIconView];
        }
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    [self resetBackgroundImageFrame];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size.width = self.frame.size.width;
    //size.height = CustomNavigationBarHeight;
    size.height = [Utility appHeight]*174;
    return size;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetBackgroundImageFrame];
}

- (IBAction)iconView:(id)sender {
    NSLog(@"iconView~~");
}


//- (void)drawRect:(CGRect)rect {
//
//    UIImage *image = [UIImage imageWithContentsOfFile:
//                      [[NSBundle mainBundle] pathForResource:@"alpha_header_bg" ofType:@"png"]];
//
//    //[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [image drawInRect:CGRectMake(0, 0, [Utility appWidth]*1200 , [Utility appHeight]*174)];
//}
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize newSize = CGSizeMake([Utility appWidth]*1200, [Utility appHeight]*400);
//    return newSize;
//}

@end
