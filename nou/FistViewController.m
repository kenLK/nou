//
//  FistViewController.m
//  nou
//
//  Created by Ken on 2014/10/30.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "FistViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "SecondViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FistViewController ()<RATreeViewDelegate, RATreeViewDataSource>


@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) NSDictionary *resultJSON;
@property (strong, nonatomic) NSMutableArray *backgroundColorArray;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation FistViewController
@synthesize resultJSON,url,backgroundColorArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;//screenRect.size.height;
    
    CGFloat yWidth = screenWidth / 1200.0;
    CGFloat yHeight = screenHeight / 1920.0;
    
    backgroundColorArray = [[NSMutableArray alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *domainURL = [dict objectForKey:@"nou_url"];
    NSLog(@"domain_url>>>>>%@",domainURL);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stno = [userDefaults stringForKey:@"account"];
    NSString *VALID_STR = [userDefaults stringForKey:@"VALID_STR"];
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@index?ACCOUNT=100100362&stno=%@&VALID_STR=%@",domainURL,stno, VALID_STR];

    if ([self.url isKindOfClass:[NSString class]]) {
        urlString = [[NSString alloc] initWithFormat:@"%@%@?stno=%@&VALID_STR=%@",domainURL,self.url,stno, VALID_STR];
    }
    NSLog(@"urlString>>>>>%@",urlString);
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc] init];
    
    [urlrequest setTimeoutInterval:20];
    
    [urlrequest setURL:[NSURL URLWithString:urlString]];
    
    
    
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:urlrequest
                    
                                         returningResponse:&response
                    
                                                     error:&error];
    if (data != nil) {
        
        resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    /*
    
    UIButton* buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buyButton setFrame:CGRectMake(10.0, 120.0+100*i,100.0, 20.0)];
    [buyButton setTitle:[content objectAtIndex:MPItemPrice] forState:UIControlStateNormal];
    [buyButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    */
    UIButton *parnetMENU = nil;
    UIButton *childMENU = nil;
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    NSDictionary *headDic = [resultJSON valueForKey:@"HEAD"];
    NSString *headName = [headDic objectForKey:@"HEADER_NAME"];
    if ([headName isKindOfClass:[NSString class]]) {
//        self.navigationController.top = headName;
    }
    float totalParnetMenuHeigh = 0.0f;
    float totalChildMenuHeigh = 0.0f;
//    for(NSDictionary *menuDic in menuArray) {
    for (int i=0; i<[menuArray count]; i++) {
        NSDictionary *menuDic = menuArray[i];
//        NSLog(@"%@>>>>>>%zd", [menuDic objectForKey:@"NAME"],(30*i));

        parnetMENU = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        totalParnetMenuHeigh = (30*i+80);
        [parnetMENU setFrame:CGRectMake(10.0, totalParnetMenuHeigh+totalChildMenuHeigh,100.0, 30.0)];

        [parnetMENU setTitle:[menuDic objectForKey:@"NAME"] forState:UIControlStateNormal];
        [parnetMENU.titleLabel setFont:[UIFont systemFontOfSize:10]];
//        [self.view addSubview:parnetMENU];
        
        NSArray *detailArray = [menuDic objectForKey:@"DETAIL"];
        if (detailArray.count > 0) {
            UIScrollView *subView = [[UIScrollView alloc] initWithFrame: CGRectMake(50, totalParnetMenuHeigh+totalChildMenuHeigh, 100, 25*[detailArray count])];
//            NSLog(@"high>>>>>>%zd",[detailArray count]);
            
            for (int j=0; j<[detailArray count]; j++) {

                NSDictionary *detailDic = detailArray[j];
                childMENU = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [childMENU setFrame:CGRectMake(50.0, subView.frame.size.height+25*j,100.0, 20.0)];
                [childMENU setTitle:[detailDic objectForKey:@"NAME"] forState:UIControlStateNormal];
                [childMENU.titleLabel setFont:[UIFont systemFontOfSize:10]];
//                [subView addSubview:childMENU];
//                [self.view addSubview:subView];
                totalChildMenuHeigh = totalChildMenuHeigh+(25*j);
            }
            if (i > 0) {
                subView.hidden = YES;
            }
        }
    }
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
            NSLog(@"backgroundColor>>>>>>%@",[self colorWithHexString:[self checkNull:[secondDic objectForKey:@"BACKGROUND_COLOR"]]]);
            if (i == 0) {
                [backgroundColorArray addObject:[self checkNull:[secondDic objectForKey:@"BACKGROUND_COLOR"]]];
            }
        }
        
        RADataObject *mainMENUName = [RADataObject dataObjectWithName:[menuDic objectForKey:@"NAME"] children:[NSArray arrayWithArray:secondMENU]];
        [fistMENU addObject:mainMENUName];
    }
    
    
    RADataObject *menu = [RADataObject dataObjectWithName:@"MENU"
                                                  children:[NSArray arrayWithArray:fistMENU]];
    
    
//    self.data = [NSArray arrayWithObjects:mainMENU[0],mainMENU[1], nil];
    self.data =[NSArray arrayWithArray:fistMENU];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0.0 , yHeight*100.0, yWidth*1200, yHeight*1820)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
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
        cell.backgroundColor = UIColorFromRGB([colorStr intValue]);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
//        cell.backgroundColor = UIColorFromRGB([colorStr intValue]);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
//        cell.backgroundColor = UIColorFromRGB([colorStr intValue]);
    }
}
//willSelectRowForItem
- (void)treeView:(RATreeView *)treeView  didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{
    NSLog(@"selected %d", treeNodeInfo.treeDepthLevel);
    SecondViewController *secondView = [[SecondViewController alloc] init];

//    [self presentViewController:secondView animated:YES completion:^{
//    }];
    
    if (treeNodeInfo.treeDepthLevel == 0) {
        //[self.navigationController pushViewController:secondView animated:YES];
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        RADataObject *dataObj = item;
        secondView.url = dataObj.url;
        NSLog(@"url>>>>%@",secondView.url);
        [self.navigationController pushViewController:secondView animated:YES];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        RADataObject *dataObj = item;
        secondView.url = dataObj.url;
        
        NSLog(@"url>>>>%@",secondView.url);
        [self.navigationController pushViewController:secondView animated:YES];
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.textLabel.textColor = [self colorWithHexString:((RADataObject *)item).textColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
//        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
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

@end
