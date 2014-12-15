//
//  SecondViewController.m
//  nou
//
//  Created by Ken on 2014/10/30.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "SecondViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "FistViewController.h"
#import "IconViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SecondViewController ()<RATreeViewDelegate, RATreeViewDataSource>
- (NSString*)checkNull:(NSString *)str;
-(UIColor *) colorWithHexString: (NSString *) stringToConvert;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) NSDictionary *resultJSON;

@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation SecondViewController
@synthesize resultJSON,url;

- (NSString*)checkNull:(NSString *)str{
    
    if ([str isKindOfClass:[NSString class]] && [str length] > 0) {
        return str;
    }
    else {
        return @"";
    }
}
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
-(UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
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
    
    NSData *data = [NouRequest urlAll: [Utility setUrlWithString:self.url parameterMap:@"" autoValid:YES]];
    
    if (data != nil) {
        
        resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    
//    UIButton *parnetMENU = nil;
//    UIButton *childMENU = nil;
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    NSDictionary *headDic = [resultJSON valueForKey:@"HEADER"];
    NSString *headName = [headDic objectForKey:@"HEADER_NAME"];
    if ([headName isKindOfClass:[NSString class]]) {
        //        self.navigationController.top = headName;
        UILabel *functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, [Utility appHeight]*174)];
        [functionTitleLabel setText:headName];
        [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
        self.navigationItem.titleView = functionTitleLabel;
    }
    
    
//    float totalParnetMenuHeigh = 0.0f;
//    float totalChildMenuHeigh = 0.0f;
//    //    for(NSDictionary *menuDic in menuArray) {
//    for (int i=0; i<[menuArray count]; i++) {
//        NSDictionary *menuDic = menuArray[i];
//        //        NSLog(@"%@>>>>>>%zd", [menuDic objectForKey:@"NAME"],(30*i));
//        
//        parnetMENU = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        totalParnetMenuHeigh = (30*i+80);
//        [parnetMENU setFrame:CGRectMake(10.0, totalParnetMenuHeigh+totalChildMenuHeigh,100.0, 30.0)];
//        
//        [parnetMENU setTitle:[menuDic objectForKey:@"NAME"] forState:UIControlStateNormal];
//        [parnetMENU.titleLabel setFont:[UIFont systemFontOfSize:10]];
//        //        [self.view addSubview:parnetMENU];
//        
//        NSArray *detailArray = [menuDic objectForKey:@"DETAIL"];
//        if (detailArray.count > 0) {
//            UIScrollView *subView = [[UIScrollView alloc] initWithFrame: CGRectMake(50, totalParnetMenuHeigh+totalChildMenuHeigh, 100, 25*[detailArray count])];
//            //            NSLog(@"high>>>>>>%zd",[detailArray count]);
//            
//            for (int j=0; j<[detailArray count]; j++) {
//                
//                NSDictionary *detailDic = detailArray[j];
//                childMENU = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                [childMENU setFrame:CGRectMake(50.0, subView.frame.size.height+25*j,100.0, 20.0)];
//                [childMENU setTitle:[detailDic objectForKey:@"NAME"] forState:UIControlStateNormal];
//                [childMENU.titleLabel setFont:[UIFont systemFontOfSize:10]];
//                //                [subView addSubview:childMENU];
//                //                [self.view addSubview:subView];
//                totalChildMenuHeigh = totalChildMenuHeigh+(25*j);
//            }
//            if (i > 0) {
//                subView.hidden = YES;
//            }
//        }
//    }
    NSMutableArray *fistMENU = [[NSMutableArray alloc] init];
    for (int i=0; i<[menuArray count]; i++) {
        NSDictionary *menuDic = menuArray[i];
        
        NSMutableArray *secondMENUArray = [menuDic objectForKey:@"DETAIL"];
        NSMutableArray *secondMENU = [[NSMutableArray alloc] init];
        RADataObject *secondMENUName = nil;
        for (int j = 0; j < [secondMENUArray count]; j++) {
            NSDictionary *secondDic = secondMENUArray[j];
            
            
            NSMutableArray *thirdMENUArray = [secondDic objectForKey:@"DETAIL"];
            NSMutableArray *thirdMENU = [[NSMutableArray alloc] init];
            RADataObject *thirdMENUName = nil;
            for (int k=0; k<[thirdMENUArray count]; k++) {
                NSDictionary *thirdDic = thirdMENUArray[k];
                
                NSMutableArray *fourthMENUArray = [thirdDic objectForKey:@"DETAIL"];
                NSMutableArray *fourthMENU = [[NSMutableArray alloc] init];
                RADataObject *fourthMENUName = nil;
                for (int l=0; l<[fourthMENUArray count]; l++) {
                    NSDictionary *fourthDic = fourthMENUArray[l];
                    
                    fourthMENUName = [RADataObject dataObjectWithName:[self checkNull:[fourthDic objectForKey:@"NAME"]] children:nil];
                    fourthMENUName.url = [self checkNull:[fourthDic objectForKey:@"URL"]];
                    fourthMENUName.backgroundColor = [self checkNull:[fourthDic objectForKey:@"BACKGROUND_COLOR"]];
                    fourthMENUName.detailVisible = [self checkNull:[fourthDic objectForKey:@"DETAIL_VISIBLE"]];
                    fourthMENUName.textColor = [self checkNull:[fourthDic objectForKey:@"TEXT_COLOR"]];
                    [fourthMENU addObject:fourthMENUName];
                    
                }
                
                
                thirdMENUName = [RADataObject dataObjectWithName:[self checkNull:[thirdDic objectForKey:@"NAME"]] children:[NSArray arrayWithArray:fourthMENU]];
                thirdMENUName.url = [self checkNull:[thirdDic objectForKey:@"URL"]];
                thirdMENUName.backgroundColor = [self checkNull:[thirdDic objectForKey:@"BACKGROUND_COLOR"]];
                thirdMENUName.detailVisible = [self checkNull:[thirdDic objectForKey:@"DETAIL_VISIBLE"]];
                thirdMENUName.textColor = [self checkNull:[thirdDic objectForKey:@"TEXT_COLOR"]];
                [thirdMENU addObject:thirdMENUName];
            }
            
            
            secondMENUName = [RADataObject dataObjectWithName:[self checkNull:[secondDic objectForKey:@"NAME"]] children:[NSArray arrayWithArray:thirdMENU]];
            secondMENUName.url = [self checkNull:[secondDic objectForKey:@"URL"]];
            secondMENUName.backgroundColor = [self checkNull:[secondDic objectForKey:@"BACKGROUND_COLOR"]];
            secondMENUName.detailVisible = [self checkNull:[secondDic objectForKey:@"DETAIL_VISIBLE"]];
            secondMENUName.textColor = [self checkNull:[secondDic objectForKey:@"TEXT_COLOR"]];
            [secondMENU addObject:secondMENUName];
            //NSLog(@"backgroundColor>>>>>>%@",[self colorWithHexString:[self checkNull:[secondDic objectForKey:@"BACKGROUND_COLOR"]]]);
//            if (i == 0) {
//                [backgroundColorArray addObject:[self checkNull:[secondDic objectForKey:@"BACKGROUND_COLOR"]]];
//            }
        }
        
        RADataObject *mainMENUName = [RADataObject dataObjectWithName:[menuDic objectForKey:@"NAME"] children:[NSArray arrayWithArray:secondMENU]];
        mainMENUName.backgroundColor = [self checkNull:[menuDic objectForKey:@"BACKGROUND_COLOR"]];
        mainMENUName.textColor = [self checkNull:[menuDic objectForKey:@"TEXT_COLOR"]];
        [fistMENU addObject:mainMENUName];
    }
    
    
    RADataObject *menu = [RADataObject dataObjectWithName:@"MENU"
                                                 children:[NSArray arrayWithArray:fistMENU]];
    
    
    //    self.data = [NSArray arrayWithObjects:mainMENU[0],mainMENU[1], nil];
    self.data =[NSArray arrayWithArray:fistMENU];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"bg_V" ofType:@"jpg"]];
    [backImageView setImage:backgroundImage];
    [treeView setBackgroundView:backImageView];
    
    [treeView reloadData];
    [treeView expandRowForItem:menu withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *dataObj = item;
    NSString *colorStr = [NSString stringWithFormat:@"%@",dataObj.backgroundColor];
    NSLog(@"%d", [colorStr intValue]);
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = [Utility colorFromHexString:colorStr];//UIColorFromRGB([colorStr intValue]);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = [Utility colorFromHexString:colorStr];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = [Utility colorFromHexString:colorStr];
    }
}
//willSelectRowForItem
- (void)treeView:(RATreeView *)treeView  didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{
    NSLog(@"selected");
    //FistViewController *firstView = [[FistViewController alloc] init];
    SecondViewController *firstView = [[SecondViewController alloc] init];
    
    
//    firstView.title=

//    [self presentViewController:secondView animated:YES completion:^{        
//    }];
    if (treeNodeInfo.treeDepthLevel == 0) {
            
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        RADataObject *dataObj = item;
        firstView.url = dataObj.url;
        [self.navigationController pushViewController:firstView animated:YES];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        RADataObject *dataObj = item;
        firstView.url = dataObj.url;
        [self.navigationController pushViewController:firstView animated:YES];
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
//    //NSInteger numberOfChildren = [treeNodeInfo.children count];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
//    cell.textLabel.text = ((RADataObject *)item).name;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (treeNodeInfo.treeDepthLevel == 0) {
//        cell.detailTextLabel.textColor = [UIColor blackColor];
//    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.textLabel.textColor = [self colorWithHexString:((RADataObject *)item).textColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        
    }
    
    if ([treeNodeInfo.children count] > 0) {
        UIImage *btnImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_off" ofType:@"png"]];
        cell.imageView.image = btnImage;
        
        CGSize itemSize = CGSizeMake([Utility appWidth]*60, [Utility appHeight]*60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return cell;
}
#pragma mark TreeView Editing
-(BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return NO;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

-(void)goHome:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *iconViewController = [[IconViewController alloc] init];
    [self presentModalViewController:iconViewController animated:NO];
}

@end
