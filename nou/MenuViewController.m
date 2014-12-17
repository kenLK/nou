//
//  MenuViewController.m
//  nou
//
//  Created by focusardi on 2014/12/15.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "MenuViewController.h"

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MenuViewController ()<RATreeViewDelegate, RATreeViewDataSource>//, UIPickerViewDelegate, UIPickerViewDataSource

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) NSDictionary *resultJSON;
@property (strong, nonatomic) NSMutableArray *backgroundColorArray;
@property (weak, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) IBOutlet UITextField *inputText;
@property (strong, nonatomic) NSString *queryUrl;

//for drop down list
@property (nonatomic, strong) IBOutlet UILabel *ddText;
@property (nonatomic, strong) IBOutlet UIScrollView *ddMenu;
@property (nonatomic, strong) IBOutlet UIButton *ddMenuShowButton;
- (IBAction)ddMenuShow:(UIButton *)sender;
- (IBAction)ddMenuSelectionMade:(UIButton *)sender;
@property (nonatomic, strong) NSMutableArray *BUTTON_TEXT;
@property (nonatomic, strong) NSMutableArray *BUTTON_VALUE;



@end

@implementation MenuViewController
@synthesize resultJSON,url,backgroundColorArray,inputText,queryUrl;
@synthesize ddMenu, ddText,BUTTON_TEXT,BUTTON_VALUE;
@synthesize ddMenuShowButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    //
    
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
    
    //取得資料
    NSData *data = [NouRequest urlAll: [Utility setUrlWithString:self.url parameterMap:@"" autoValid:YES]];
    if (data != nil) {
        resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    
    //HEADER
    NSDictionary *headDic = [resultJSON valueForKey:@"HEADER"];
    NSString *headName = [headDic objectForKey:@"HEADER_NAME"];
    if ([headName isKindOfClass:[NSString class]]) {
        UILabel *functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, [Utility appHeight]*174)];
        [functionTitleLabel setText:headName];
        [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
        self.navigationItem.titleView = functionTitleLabel;
    }
    
    CGFloat subjectHeight = [Utility appHeight]*112;
    //SUBJECT
    NSDictionary *subjectDic = [resultJSON valueForKey:@"SUBJECT"];
    if (subjectDic != nil) {
        NSDictionary *dropdownMenu = [subjectDic objectForKey:@"DROPDOWN_MENU"];
        NSDictionary *inputButton = [subjectDic objectForKey:@"INPUT_BUTTON"];
        
        //subject為查詢button
        if (inputButton != nil) {
             //set value
            NSString *BACKGROUND_COLOR = [Utility checkNull:[inputButton objectForKey:@"BACKGROUND_COLOR"] defaultString:@"FFFFFF"];
            NSString *TEXT_COLOR = [Utility checkNull:[inputButton objectForKey:@"TEXT_COLOR"] defaultString:@"34ADDC"];
            NSString *BORDER_COLOR = [Utility checkNull:[inputButton objectForKey:@"BORDER_COLOR"] defaultString:@"34ADDC"];
            NSString *PLACEHOLDER = [Utility checkNull:[inputButton objectForKey:@"PLACEHOLDER"] defaultString:@"請輸入..."];
            
            NSString *BUTTON_TEXT = [Utility checkNull:[inputButton objectForKey:@"BUTTON_TEXT"] defaultString:@"送出"];
            NSString *BUTTON_BACKGROUND_COLOR = [Utility checkNull:[inputButton objectForKey:@"BUTTON_BACKGROUND_COLOR"] defaultString:@"F27935"];
            NSString *BUTTON_TEXT_COLOR = [Utility checkNull:[inputButton objectForKey:@"BUTTON_TEXT_COLOR"] defaultString:@"FFFFFF"];
            NSString *URL = [Utility checkNull:[inputButton objectForKey:@"URL"] defaultString:url];
            queryUrl = URL;
            
            
            //input background
            UIImageView *passwordBgView = [[UIImageView alloc] initWithFrame:CGRectMake([Utility appWidth]*0.0 , subjectHeight + [Utility appHeight]*174, [Utility appWidth]*1200, [Utility appHeight]*100)];
            UIImage *passwordBgImage = [UIImage imageWithContentsOfFile:
                                        [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
            [passwordBgView setImage:passwordBgImage];
            [self.view addSubview:passwordBgView];
            
            //textField
            inputText = [[UITextField alloc]initWithFrame:CGRectMake([Utility appWidth]*38 , subjectHeight + [Utility appHeight]*174, [Utility appWidth]*710, [Utility appHeight]*100)];
            inputText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:PLACEHOLDER attributes:@{NSForegroundColorAttributeName: [Utility colorFromHexString:@"000000"], NSFontAttributeName:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]}];
            inputText.textColor = [Utility colorFromHexString:TEXT_COLOR];
            inputText.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
            [self.view addSubview:inputText];
            
            //button
            UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [queryButton addTarget:self
                            action:@selector(query:)
                  forControlEvents:UIControlEventTouchUpInside];
            [queryButton setTitle:BUTTON_TEXT forState:UIControlStateNormal];
            [queryButton setTitleColor:[Utility colorFromHexString:BUTTON_TEXT_COLOR] forState:UIControlStateNormal];
            queryButton.backgroundColor = [Utility colorFromHexString:BUTTON_BACKGROUND_COLOR];
            queryButton.frame = CGRectMake([Utility appWidth]*748 , subjectHeight + [Utility appHeight]*174, [Utility appWidth]*450, [Utility appHeight]*100);
            [self.view addSubview:queryButton];
            //[self.view insertSubview:queryButton atIndex:0];
            
            subjectHeight = subjectHeight + [Utility appHeight]*100;
        }
        
        //subject為下拉式選單
        if (dropdownMenu != nil) {
            //set value
            NSArray *ddArray = [dropdownMenu objectForKey:@"DETAIL"];
            
            NSString *BACKGROUND_COLOR = [Utility checkNull:[dropdownMenu objectForKey:@"BACKGROUND_COLOR"] defaultString:@"FFFFFF"];
            NSString *BORDER_COLOR = [Utility checkNull:[dropdownMenu objectForKey:@"BORDER_COLOR"] defaultString:@"34ADDC"];
            NSString *TEXT_COLOR = [Utility checkNull:[dropdownMenu objectForKey:@"TEXT_COLOR"] defaultString:@"34ADDC"];
            NSString *URL = [Utility checkNull:[dropdownMenu objectForKey:@"URL"] defaultString:url];
            queryUrl = URL;
            
            //手刻下拉選單
            BUTTON_TEXT = [[NSMutableArray alloc] init];
            BUTTON_VALUE = [[NSMutableArray alloc] init];
            
            int checkedMenu = 0;
            for (int i = 0;i < ddArray.count;i++) {
                NSDictionary *ddDic = ddArray[i];
                [BUTTON_TEXT addObject:[Utility checkNull:[ddDic objectForKey:@"NAME"] defaultString:@""]];
                [BUTTON_VALUE addObject:[Utility checkNull:[ddDic objectForKey:@"VALUE"] defaultString:@""]];
                
                if ([@"Y" isEqualToString:[ddDic objectForKey:@"SELECTED"]]) {
                    checkedMenu = i;
                }
            }
            
            
            ddMenuShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [ddMenuShowButton addTarget:self
                            action:@selector(ddMenuShow:)
                  forControlEvents:UIControlEventTouchUpInside];
            NSMutableString *menuTitle = [BUTTON_TEXT objectAtIndex:checkedMenu];
            [ddMenuShowButton setTitle:menuTitle forState:UIControlStateNormal];
            [ddMenuShowButton setTitleColor:[Utility colorFromHexString:TEXT_COLOR] forState:UIControlStateNormal];
            ddMenuShowButton.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
            ddMenuShowButton.frame = CGRectMake([Utility appWidth]*38 , subjectHeight + [Utility appHeight]*154, [Utility appWidth]*1124, [Utility appHeight]*150);
            [self.view addSubview:ddMenuShowButton];
            
            ddMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, [Utility appHeight]*1980)];
            ddMenu.contentSize = CGSizeMake([Utility appWidth]*1124, [Utility appHeight]*150*ddArray.count);
            
            for (int i = 0;i < ddArray.count;i++) {
              
                UIButton *ddMenuSelectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [ddMenuSelectButton addTarget:self
                                       action:@selector(ddMenuSelectionMade:)
                           forControlEvents:UIControlEventTouchUpInside];
                
                NSMutableString *menuTitle = [BUTTON_TEXT objectAtIndex:i];
                [ddMenuSelectButton setTag:i];
                [ddMenuSelectButton setTitle:menuTitle forState:UIControlStateNormal];
                [ddMenuSelectButton setTitleColor:[Utility colorFromHexString:TEXT_COLOR] forState:UIControlStateNormal];
                ddMenuSelectButton.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
                ddMenuSelectButton.frame = CGRectMake([Utility appWidth]*38 , subjectHeight + [Utility appHeight]*174 + [Utility appHeight]*150 * (i+1), [Utility appWidth]*1124, [Utility appHeight]*150);
                [ddMenu addSubview:ddMenuSelectButton];
                
            }
            [self.view addSubview:ddMenu];
            
            self.ddMenu.hidden = YES;
            
            subjectHeight = subjectHeight + [Utility appHeight]*100;
            
        }
        
    }
    
    
    
    //MENU
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    
    NSMutableArray *firstMENU = [[NSMutableArray alloc] init];
    
    //parse JSON
    firstMENU = [self addMenuTree:menuArray];
    
    //加上logo
//    RADataObject *logoMENUName0 = nil;
//    logoMENUName0 = [RADataObject dataObjectWithName:[Utility checkNull:@"LOGO0"] children:nil];
//    logoMENUName0.isSelective = NO;
//    [firstMENU addObject:logoMENUName0];
//    
//    RADataObject *logoMENUName = nil;
//    logoMENUName = [RADataObject dataObjectWithName:[Utility checkNull:@"LOGO"] children:nil];
//    logoMENUName.isSelective = NO;
//    logoMENUName.isLogo = YES;
//    
//    [firstMENU addObject:logoMENUName];
    
    //產TreeView
    RADataObject *menu = [RADataObject dataObjectWithName:@"MENU" children:[NSArray arrayWithArray:firstMENU]];

    self.data =[NSArray arrayWithArray:firstMENU];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0.0, subjectHeight, [Utility boundWidth]*1200, [Utility boundHeight]*1920)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    [treeView expandRowForItem:menu withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"bg_V" ofType:@"jpg"]];
    [backImageView setImage:backgroundImage];
    
    [treeView setBackgroundView:backImageView];
    
    self.treeView = treeView;
    //[self.view addSubview:treeView];
    [self.view insertSubview:treeView atIndex:1];//background為0
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *) addMenuTree:(NSArray *)menuArray {
    //parse資料遞迴
    if ([menuArray count] == 0) {
        return nil;
    }
    
    NSMutableArray *fourthMENU = [[NSMutableArray alloc] init];
    RADataObject *fourthMENUName = nil;
    
    for (int l=0; l<[menuArray count]; l++) {
        NSDictionary *fourthDic = menuArray[l];
        
        //NAME - 一般文字
        //TEXT - 有可能換行的長文字
        //TEXTAREA - 要換行的長文字
        NSString *tempText = [fourthDic objectForKey:@"TEXT"];
        NSString *tempTextArea = [fourthDic objectForKey:@"TEXTAREA"];
        NSString *tempName = [fourthDic objectForKey:@"NAME"];
        NSString *tempObject = [Utility checkNull:tempName defaultString:[Utility checkNull:tempText defaultString:tempTextArea]];
        
        fourthMENUName = [RADataObject dataObjectWithName:tempObject children:[self addMenuTree:[fourthDic objectForKey:@"DETAIL"]]];
        fourthMENUName.url = [Utility checkNull:[fourthDic objectForKey:@"URL"]];
        fourthMENUName.backgroundColor = [Utility checkNull:[fourthDic objectForKey:@"BACKGROUND_COLOR"]];
        fourthMENUName.detailVisible = [Utility checkNull:[fourthDic objectForKey:@"DETAIL_VISIBLE"]];
        fourthMENUName.textColor = [Utility checkNull:[fourthDic objectForKey:@"TEXT_COLOR"]];
        fourthMENUName.columnAlign = [fourthDic objectForKey:@"COLUMN_ALIGN"];
        fourthMENUName.columnWidth = [fourthDic objectForKey:@"COLUMN_WIDTH"];
        fourthMENUName.isChildDefaultExpanded = [Utility ynToBool:[fourthDic objectForKey:@"DETAIL_VISIBLE"]];
        
        if (tempText != nil || tempTextArea != nil) {
            fourthMENUName.isMultiLine = YES;
        }

        
        [fourthMENU addObject:fourthMENUName];
    }
    
    return fourthMENU;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *dataObj = (RADataObject *) item;
    
    if (dataObj.isMultiLine) {
        //return 94;
    }
    
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
    
    //自動展開項目
    if (((RADataObject *) item).isChildDefaultExpanded == YES) {
        return YES;
    }
    
    return NO;
}
- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    cell.backgroundColor = [Utility colorFromHexString:((RADataObject *)item).backgroundColor];
    
    //for 預設展開的項目
    if ([treeNodeInfo.children count] > 0) {
        NSString *pic;
        if (!((RADataObject *) item).isChildDefaultExpanded) {
            pic = @"icon_off";
        } else {
            pic = @"icon_on";
        }
        
        UIImage *btnImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pic ofType:@"png"]];
        cell.imageView.image = btnImage;
        
        CGSize itemSize = CGSizeMake([Utility appWidth]*60, [Utility appHeight]*60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}
- (void)treeView:(RATreeView *)treeView  didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo{

    //點選的項目
    
    MenuViewController *secondView = [[MenuViewController alloc] init];
    
    if ([treeNodeInfo.children count] > 0) {
        NSString *pic;
        if (treeNodeInfo.expanded) {
            pic = @"icon_off";
        } else {
            pic = @"icon_on";
        }
        
        UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
        UIImage *btnImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pic ofType:@"png"]];
        cell.imageView.image = btnImage;
        
        CGSize itemSize = CGSizeMake([Utility appWidth]*60, [Utility appHeight]*60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (treeNodeInfo.treeDepthLevel == 0) {
        
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
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    //假如為LOGO
    if (((RADataObject *)item).isLogo) {
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake([Utility appWidth]*395, [Utility appHeight]*30, [Utility appWidth]*410, [Utility appHeight]*90)];
        UIImage *logoImage = [UIImage imageWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"icon_logo" ofType:@"png"]];
        [logoImageView setImage:logoImage];
        [cell addSubview:logoImageView];
        
    }
    
    
    //若NAME為Array，則版面為table
    NSArray *nameArray = [Utility stringToArray:((RADataObject *)item).name];
    
    if (nameArray.count < 2) {
        //無Array
        
        cell.textLabel.text = ((RADataObject *)item).name;
        cell.textLabel.textColor = [Utility colorFromHexString:((RADataObject *)item).textColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        //有Array
        NSArray *alignArray = ((RADataObject *)item).columnAlign;
        NSArray *widthArray = ((RADataObject *)item).columnWidth;
        
        CGFloat widthLocation = 0.0;
        CGRect appRect = [[UIScreen mainScreen] bounds];
        CGFloat appWidth = appRect.size.width;
        
        for (int i = 0;i < nameArray.count;i++) {
            
            CGFloat labelWidth = appWidth * ([widthArray[i] floatValue] / 100);
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthLocation, 0.0, labelWidth, 47)];
            [titleLabel setText:nameArray[i]];
            [titleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*60]];
            titleLabel.textColor = [Utility colorFromHexString:((RADataObject *)item).textColor];
            [titleLabel setTextAlignment:[Utility alignTextToNSTextAlignment:alignArray[i]]];
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [cell addSubview:titleLabel];

            widthLocation += labelWidth + 5;
        
        }
        
        
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
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}
#pragma mark TreeView Editing
-(BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return NO;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

//手刻下拉選單
- (IBAction)ddMenuShow:(UIButton *)sender
{
    NSLog(@"ddMenuShow:");
    if (sender.tag == 0) {
        sender.tag = 1;
        self.ddMenu.hidden = NO;
        //[sender setTitle:@"▲" forState:UIControlStateNormal];
    } else {
        sender.tag = 0;
        self.ddMenu.hidden = YES;
        //[sender setTitle:@"▼" forState:UIControlStateNormal];
    }
}
- (IBAction)ddMenuSelectionMade:(UIButton *)sender
{
    NSLog(@"ddMenuSelectionMade:");
    self.ddText.text = sender.titleLabel.text;
    [self.ddMenuShowButton setTitle:[BUTTON_TEXT objectAtIndex:sender.tag] forState:UIControlStateNormal];
    self.ddMenuShowButton.tag = 0;
    self.ddMenu.hidden = YES;
    
    //傳值前先encode
    NSString *escapedString = [[BUTTON_VALUE objectAtIndex:sender.tag] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    //查詢參數帶p
    NSString *queryString = [[NSString alloc] initWithFormat:@"%@?p=%@",queryUrl, escapedString];
    
    MenuViewController *secondView = [[MenuViewController alloc] init];
    secondView.url = queryString;
    
    [self.navigationController pushViewController:secondView animated:YES];
}



-(void)goHome:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *iconViewController = [[IconViewController alloc] init];
    [self presentModalViewController:iconViewController animated:NO];
}
-(void)query:(id)sender {
    
    MenuViewController *secondView = [[MenuViewController alloc] init];
    
    //傳值前先encode
    NSString *escapedString = [inputText.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    //查詢參數帶p
    NSString *queryString = [[NSString alloc] initWithFormat:@"%@?p=%@",queryUrl, escapedString];
    
    secondView.url = queryString;
    
    [self.navigationController pushViewController:secondView animated:YES];
}
@end

