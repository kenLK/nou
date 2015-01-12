//
//  MenuViewController.m
//  nou
//
//  Created by focusardi on 2014/12/15.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "MenuViewController.h"

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MenuViewController ()<RATreeViewDelegate, RATreeViewDataSource, GMSMapViewDelegate>

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
@property (nonatomic, strong) NSMutableArray *ddBUTTON_TEXT;
@property (nonatomic, strong) NSMutableArray *ddBUTTON_VALUE;

@property (strong, nonatomic) NSString *navTitle;
@end

@implementation MenuViewController {
    GMSMapView *mapView_;
}
@synthesize resultJSON,url,backgroundColorArray,inputText,queryUrl;
@synthesize ddMenu, ddText,ddMenuShowButton,ddBUTTON_TEXT,ddBUTTON_VALUE;
@synthesize isIndex,navTitle;

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageWithContentsOfFile:
                                                         [[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageWithContentsOfFile:
                                                                       [[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]]];
//    self.navigationItem.title = navTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    
    
    UIImageView *backgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , 0.0, screenRect.size.width, screenRect.size.height)];
    UIImage *backgImage = [UIImage imageWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:@"white" ofType:@"jpg"]];
    [backgImageView setImage:backgImage];
    [self.view addSubview:backgImageView];
    
    
    //取得資料
    NSData *data = [NouRequest urlAll: [Utility setUrlWithString:self.url parameterMap:@"" autoValid:YES]];
    if (data != nil) {
        resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //消除重試navi
        
    } else {
        [self errorNetwork];
    }
    
    //HEADER
    NSDictionary *headDic = [resultJSON valueForKey:@"HEADER"];
    NSString *headName = [headDic objectForKey:@"HEADER_NAME"];
    if ([headName isKindOfClass:[NSString class]]) {
        UILabel *functionTitleLabel;
        UIFont* titleFont = [UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*60];
        CGSize requestedTitleSize = [headName sizeWithFont:titleFont];
        CGFloat titleWidth = MIN([Utility appWidth]*1000, requestedTitleSize.width);
        
        functionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, titleWidth, [Utility appHeight]*174)];
        [functionTitleLabel setText:headName];
        [functionTitleLabel setTextAlignment:NSTextAlignmentCenter];
        self.navigationItem.titleView = functionTitleLabel;
    }
    
    if (![@"" isEqualToString:[Utility checkNull:[headDic objectForKey:@"RIGHT_URL"] defaultString:@""]]) {
        self.isIndex = YES;
    }
    
    //CGFloat subjectHeight = [Utility appHeight]*112;
    
    CGFloat subjectHeight = self.navigationController.navigationBar.frame.size.height;
    subjectHeight = 10;
    
    //SUBJECT
    NSDictionary *subjectDic = [resultJSON valueForKey:@"SUBJECT"];
    if (subjectDic != nil) {
        //SUBJECT分三種
        NSDictionary *dropdownMenu = [subjectDic objectForKey:@"DROPDOWN_MENU"];
        NSDictionary *inputButton = [subjectDic objectForKey:@"INPUT_BUTTON"];
        NSString *subjectName = [Utility checkNull:[subjectDic objectForKey:@"NAME"]];
        
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
            UIImageView *passwordBgView = [[UIImageView alloc] initWithFrame:CGRectMake([Utility appWidth]*0.0 , subjectHeight, [Utility appWidth]*1200, [Utility appHeight]*174)];
            UIImage *passwordBgImage = [UIImage imageWithContentsOfFile:
                                        [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
            [passwordBgView setImage:passwordBgImage];
            [self.view addSubview:passwordBgView];
            
            //textField
            inputText = [[UITextField alloc]initWithFrame:CGRectMake([Utility appWidth]*38 , subjectHeight + [Utility appHeight]*30, [Utility appWidth]*790, [Utility appHeight]*174 - [Utility appHeight]*30)];
            inputText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:PLACEHOLDER attributes:@{NSForegroundColorAttributeName: [Utility colorFromHexString:TEXT_COLOR], NSFontAttributeName:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]}];
            inputText.textColor = [Utility colorFromHexString:TEXT_COLOR];
            inputText.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
            inputText.layer.borderColor = [Utility colorFromHexString:BORDER_COLOR].CGColor;
            inputText.layer.borderWidth = 1.0;
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            inputText.leftView = paddingView;
            inputText.leftViewMode = UITextFieldViewModeAlways;
            
            [self.view addSubview:inputText];
            
            //cancel text
            UIButton *clearAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            clearAccountButton.frame = CGRectMake([Utility appWidth]*680 , subjectHeight + [Utility appHeight]*30, [Utility appWidth]*140, [Utility appHeight]*140);
            [clearAccountButton addTarget:self action:@selector(clearAccount:) forControlEvents:UIControlEventTouchUpInside];
            UIImage *clearAccountImage = [UIImage imageWithContentsOfFile:
                                          [[NSBundle mainBundle] pathForResource:@"icon_clear" ofType:@"png"]];
            [clearAccountButton setImage:clearAccountImage forState:UIControlStateNormal];
            UIImage *clearAccountOverImage = [UIImage imageWithContentsOfFile:
                                              [[NSBundle mainBundle] pathForResource:@"icon_clear_over" ofType:@"png"]];
            [clearAccountButton setImage:clearAccountOverImage forState:UIControlStateHighlighted];
            [self.view insertSubview:clearAccountButton aboveSubview:inputText];
            
            //button
            UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [queryButton addTarget:self
                            action:@selector(query:)
                  forControlEvents:UIControlEventTouchUpInside];
            [queryButton setTitle:BUTTON_TEXT forState:UIControlStateNormal];
            [queryButton setTitleColor:[Utility colorFromHexString:BUTTON_TEXT_COLOR] forState:UIControlStateNormal];
            queryButton.backgroundColor = [Utility colorFromHexString:BUTTON_BACKGROUND_COLOR];
            queryButton.frame = CGRectMake([Utility appWidth]*848 , subjectHeight + [Utility appHeight]*30, [Utility appWidth]*320, [Utility appHeight]*174 - [Utility appHeight]*30);
            [self.view addSubview:queryButton];
            
            subjectHeight = subjectHeight + 13;
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
            ddBUTTON_TEXT = [[NSMutableArray alloc] init];
            ddBUTTON_VALUE = [[NSMutableArray alloc] init];
            
            int checkedMenu = 0;
            for (int i = 0;i < ddArray.count;i++) {
                NSDictionary *ddDic = ddArray[i];
                [ddBUTTON_TEXT addObject:[Utility checkNull:[ddDic objectForKey:@"NAME"] defaultString:@""]];
                [ddBUTTON_VALUE addObject:[Utility checkNull:[ddDic objectForKey:@"VALUE"] defaultString:@""]];
                
                if ([@"Y" isEqualToString:[ddDic objectForKey:@"SELECTED"]]) {
                    checkedMenu = i;
                }
            }
            
            
            ddMenuShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [ddMenuShowButton addTarget:self
                            action:@selector(ddMenuShow:)
                  forControlEvents:UIControlEventTouchUpInside];
            NSMutableString *menuTitle = [ddBUTTON_TEXT objectAtIndex:checkedMenu];
            [ddMenuShowButton setTitle:menuTitle forState:UIControlStateNormal];
            [ddMenuShowButton setTitleColor:[Utility colorFromHexString:TEXT_COLOR] forState:UIControlStateNormal];
            ddMenuShowButton.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
            ddMenuShowButton.frame = CGRectMake([Utility appWidth]*20 , subjectHeight + 4, [Utility appWidth]*1160, [Utility appHeight]*150);
            ddMenuShowButton.layer.borderColor = [Utility colorFromHexString:BORDER_COLOR].CGColor;
            ddMenuShowButton.layer.borderWidth = 1.0;
            [self.view addSubview:ddMenuShowButton];
            
            UIImageView *buttonView = [[UIImageView alloc] initWithFrame:CGRectMake([Utility appWidth]*1068 , subjectHeight + 4 +4, [Utility appWidth]*112, [Utility appHeight]*125)];
            UIImage *buttonImg = [UIImage imageWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"icon_dropmenu" ofType:@"png"]];
            [buttonView setImage:buttonImg];
            [self.view insertSubview:buttonView aboveSubview:ddMenuShowButton];
            
            
            
            ddMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, [Utility appHeight]*1980)];
            ddMenu.contentSize = CGSizeMake([Utility appWidth]*1124, [Utility appHeight]*150*(ddArray.count+4));
            
            for (int i = 0;i < ddArray.count;i++) {
              
                UIButton *ddMenuSelectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [ddMenuSelectButton addTarget:self
                                       action:@selector(ddMenuSelectionMade:)
                           forControlEvents:UIControlEventTouchUpInside];
                
                NSMutableString *menuTitle = [ddBUTTON_TEXT objectAtIndex:i];
                [ddMenuSelectButton setTag:i];
                [ddMenuSelectButton setTitle:menuTitle forState:UIControlStateNormal];
                [ddMenuSelectButton setTitleColor:[Utility colorFromHexString:TEXT_COLOR] forState:UIControlStateNormal];
                ddMenuSelectButton.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
                ddMenuSelectButton.frame = CGRectMake([Utility appWidth]*20 , subjectHeight + [Utility appHeight]*174 + [Utility appHeight]*150 * (i+1), [Utility appWidth]*1160, [Utility appHeight]*150);
                ddMenuSelectButton.layer.borderColor = [Utility colorFromHexString:BORDER_COLOR].CGColor;
                ddMenuSelectButton.layer.borderWidth = 1.0;
                [ddMenu addSubview:ddMenuSelectButton];
            }
            
            [self.view addSubview:ddMenu];
            
            self.ddMenu.hidden = YES;
            
            subjectHeight = subjectHeight + 20;
            
        }
        
        
        //NAME
        if (![subjectName isEqualToString:@""]) {
            NSString *BACKGROUND_COLOR = [Utility checkNull:[subjectDic objectForKey:@"BACKGROUND_COLOR"] defaultString:@"FFFFFF"];
            NSString *TEXT_COLOR = [Utility checkNull:[subjectDic objectForKey:@"TEXT_COLOR"] defaultString:@"34ADDC"];
            NSString *BORDER_COLOR = [Utility checkNull:[subjectDic objectForKey:@"BORDER_COLOR"] defaultString:@"34ADDC"];
            
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([Utility appWidth]*0.0 , subjectHeight, [Utility appWidth]*1200, [Utility appHeight]*174)];
            [titleLabel setText:subjectName];
            [titleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*60]];
            titleLabel.backgroundColor = [Utility colorFromHexString:BACKGROUND_COLOR];
            titleLabel.textColor = [Utility colorFromHexString:TEXT_COLOR];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:titleLabel];
            
            subjectHeight = subjectHeight + 20;
        }
    } else {
        subjectHeight = subjectHeight - 12;
    
    }
    
    
    //MENU
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    
    NSMutableArray *firstMENU = [[NSMutableArray alloc] init];
    
    //parse JSON
    firstMENU = [self addMenuTree:menuArray];
    
//    //加上logo
//    RADataObject *logoMENUName0 = nil;
//    logoMENUName0 = [RADataObject dataObjectWithName:[Utility checkNull:@"LOGO0"] children:nil];
//    logoMENUName0.multiLineHeight = 47;
//    logoMENUName0.isNotSelective = YES;
//    [firstMENU addObject:logoMENUName0];
//    
//    RADataObject *logoMENUName = nil;
//    logoMENUName = [RADataObject dataObjectWithName:[Utility checkNull:@"LOGO"] children:nil];
//    logoMENUName.multiLineHeight = 47;
//    logoMENUName.isNotSelective = YES;
//    logoMENUName.isLogo = YES;
//    
//    [firstMENU addObject:logoMENUName];
    
    //產TreeView
    RADataObject *menu = [RADataObject dataObjectWithName:@"MENU" children:[NSArray arrayWithArray:firstMENU]];

    self.data =[NSArray arrayWithArray:firstMENU];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0.0, subjectHeight + 2, [Utility boundWidth]*1200, [Utility appHeight]*1920 - subjectHeight - [Utility appHeight]*160)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    treeView.separatorColor = [UIColor whiteColor];

    [treeView reloadData];
    [treeView expandRowForItem:menu withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    treeView.contentMode = UIViewContentModeScaleToFill;
    
    self.treeView = treeView;
    //[self.view addSubview:treeView];
    [self.view insertSubview:treeView atIndex:1];//background為0
    
    
    UIImageView *footerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0 , [Utility boundHeight]*1920, [Utility appWidth]*1200, 47)];
    UIImage *footerImage = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"icon_logo" ofType:@"png"]];
    [footerImageView setImage:footerImage];
    [self.view addSubview:footerImageView];
    
    
    
    
    //Navigator圖示設定
    //移除登出按鈕99, 教務系統按鈕98
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if(view.tag == 99 || view.tag == 98)
        {
            [view removeFromSuperview];
        }
    }
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageWithContentsOfFile:
                                                         [[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageWithContentsOfFile:
                                                                       [[NSBundle mainBundle] pathForResource:@"icon_back" ofType:@"png"]]];
    if (isIndex) {
        //是否顯示教務按鈕
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backBtnImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_menu" ofType:@"png"]];
        [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, [Utility appWidth]*130, [Utility appHeight]*100);
        [backBtn setTag:98];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
        self.navigationItem.rightBarButtonItem = backButton;
    }
    
    self.navigationController.navigationBar.barTintColor = [Utility colorFromHexString:@"34ADDC"];
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationController.navigationBar.backItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *) addMenuTree:(NSArray *)menuArray {
    //parse資料遞迴
    
    //遞迴終止
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
        
        //下一層遞迴
        fourthMENUName = [RADataObject dataObjectWithName:tempObject children:[self addMenuTree:[fourthDic objectForKey:@"DETAIL"]]];
        
        //parse並設定資料
        fourthMENUName.url = [Utility checkNull:[fourthDic objectForKey:@"URL"]];
        fourthMENUName.backgroundColor = [Utility checkNull:[fourthDic objectForKey:@"BACKGROUND_COLOR"]];
        fourthMENUName.textColor = [Utility checkNull:[fourthDic objectForKey:@"TEXT_COLOR"]];
        fourthMENUName.marginTop = [Utility checkNull:[fourthDic objectForKey:@"MARGIN_TOP"]];
        fourthMENUName.columnAlign = [fourthDic objectForKey:@"COLUMN_ALIGN"];
        fourthMENUName.columnWidth = [fourthDic objectForKey:@"COLUMN_WIDTH"];
        fourthMENUName.isChildDefaultExpanded = [Utility ynToBool:[fourthDic objectForKey:@"DETAIL_VISIBLE"]];
        fourthMENUName.docUrl = [Utility checkNull:[fourthDic objectForKey:@"DOC_URL"]];
        
        fourthMENUName.borderColor = [Utility checkNull:[fourthDic objectForKey:@"BORDER_COLOR"]];
        
        fourthMENUName.googleMap = [Utility checkNull:[fourthDic objectForKey:@"GOOGLE_MAP"]];
        fourthMENUName.multiAddr = [fourthDic objectForKey:@"MULTIADDR"];
        fourthMENUName.multiSnippet = [fourthDic objectForKey:@"MULTISNIPPET"];
        fourthMENUName.multiTitle = [fourthDic objectForKey:@"MULTITITLE"];
        fourthMENUName.zoom = [Utility checkNull:[fourthDic objectForKey:@"ZOOM"] defaultString:@"15"];
        fourthMENUName.multiLineHeight = 0.0;
        //計算欄位高度
        if ([@"" isEqualToString:fourthMENUName.googleMap]) {
            NSRange searchedRange = NSMakeRange(0, [tempObject length]);;
            NSError *error;
            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: @"\\n" options:0 error:&error];
            NSArray* matches = [regex matchesInString:tempObject options:0 range: searchedRange];
            if (matches.count > 0 || tempText != nil || tempTextArea != nil) {
                fourthMENUName.isMultiLine = YES;
                
                fourthMENUName.multiLineHeight = [self countHeight:tempObject];
                
//                UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1200, 0)];
//                textLabel.text = tempObject;
//                [textLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]];
//                textLabel.numberOfLines = 0;
//                [textLabel sizeToFit];
//                
//                fourthMENUName.multiLineHeight = textLabel.frame.size.height;
//                if (fourthMENUName.multiLineHeight < 47) {
//                    fourthMENUName.multiLineHeight = 47;
//                } else {
//                    fourthMENUName.multiLineHeight = textLabel.frame.size.height + 47;
//                }
            }
        }
        
        [fourthMENU addObject:fourthMENUName];
    }
    
    return fourthMENU;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *dataObj = (RADataObject *) item;
    
    if ((![((RADataObject *)item).googleMap isEqualToString:@""])) {
        //googlemap加大
        return [Utility appHeight]* 1000;
    }
    
    if (dataObj.isMultiLine) {
        return dataObj.multiLineHeight;
    }
    
    if (dataObj.multiLineHeight > 0.0) {
        return dataObj.multiLineHeight;
    }

    return [self countHeight:dataObj.name];
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
    RADataObject *dataObj = (RADataObject *)item;
    
    //背景固定白色
    cell.backgroundColor = [UIColor whiteColor];
    
    
    //非logo時，要設背景
    if (!dataObj.isLogo) {
        //cell.backgroundColor = [Utility colorFromHexString:dataObj.backgroundColor];
    }
    
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
        
        //取得cell
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
    
    RADataObject *dataObj = item;
    
    if (![dataObj.docUrl isEqualToString:@""]) {
        //資料來源，開啟safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataObj.docUrl]];
        return;
    }
    
    //跳下一頁
    if ([treeNodeInfo.children count] == 0 && ![dataObj.url isEqualToString:@""]) {
        secondView.url = dataObj.url;
        //secondView.isIndex = self.isIndex;
        NSLog(@"url>>>>%@",secondView.url);
        [self.navigationController pushViewController:secondView animated:YES];
    }
    
    
}
#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //項目顯示資料
    RADataObject *dataObj = (RADataObject *)item;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    //假如為LOGO
    if (dataObj.isLogo) {
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake([Utility appWidth]*395, [Utility appHeight]*30, [Utility appWidth]*410, [Utility appHeight]*90)];
        UIImage *logoImage = [UIImage imageWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"icon_logo" ofType:@"png"]];
        [logoImageView setImage:logoImage];
        [cell addSubview:logoImageView];
        return cell;
    }
    
    //////////////
    // 調整版面開始
    CGFloat nouCellHeight = 0.0;
    
    if ((![((RADataObject *)item).googleMap isEqualToString:@""])) {
        //googlemap加大
        nouCellHeight = [Utility appHeight]* 1000;
    } else if (dataObj.isMultiLine) {
        nouCellHeight = dataObj.multiLineHeight;
    } else if (dataObj.multiLineHeight > 0.0) {
        nouCellHeight = dataObj.multiLineHeight;
    } else {
        nouCellHeight = [self countHeight:dataObj.name];
    }
    
    //框線
    UILabel * cellBackGround;
    CGFloat marginHeight = 0;
    if ([@"" isEqualToString:dataObj.marginTop]) {
        cellBackGround = [[UILabel alloc] initWithFrame:CGRectMake([Utility appWidth]*20, 0, [Utility appWidth]*1160, nouCellHeight)];
    } else {
        //有margin
        marginHeight = [dataObj.marginTop floatValue];
        cellBackGround = [[UILabel alloc] initWithFrame:CGRectMake([Utility appWidth]*20, [Utility appHeight]*marginHeight, [Utility appWidth]*1160, nouCellHeight - [Utility appHeight]*marginHeight)];
    }

    cellBackGround.backgroundColor = [Utility colorFromHexString:dataObj.backgroundColor];
    
    if (![@"" isEqualToString:dataObj.borderColor]) {
        cellBackGround.layer.borderColor = [Utility colorFromHexString:dataObj.borderColor].CGColor;
        cellBackGround.layer.borderWidth = 1.0;
    }
    [cell insertSubview:cellBackGround atIndex:0];
    
    //cell選擇顏色
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [Utility colorFromHexString:dataObj.backgroundColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (dataObj.isNotSelective) {
        return cell;
    }
    
    
    //若NAME為Array，則版面為table
    NSArray *nameArray = [Utility stringToArray:((RADataObject *)item).name];
    
    if ((![dataObj.googleMap isEqualToString:@""])) {
        //有google map
        NouMapButton *btn01 = [NouMapButton buttonWithType:UIButtonTypeRoundedRect];
        [btn01 setTag:1];
        btn01.dataObj = dataObj;
        btn01.frame = CGRectMake([Utility appWidth]*20, [Utility appHeight]*0, [Utility appWidth]*1160, [Utility appHeight]*1200);
        [btn01 addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
        
        //取得google map image

        NSMutableString *googleMap = [[NSMutableString alloc]initWithString:@""];
        
        [googleMap appendString:@"http://maps.google.com/maps/api/staticmap?"];
        [googleMap appendFormat:@"zoom=%@", dataObj.zoom];
        [googleMap appendString:@"&size=600x600&maptype=mobile&feature:all&element:all"];
        [googleMap appendFormat:@"&markers=%@", [Utility stringEncode:dataObj.googleMap]];
        [googleMap appendString:@"&sensor=true&language=zh-tw"];
        
        if (dataObj.multiAddr == nil) {
            [googleMap appendFormat:@"&center=%@", [Utility stringEncode:dataObj.googleMap]];
        }
        //NSLog(@"google map>>%@", googleMap);
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: googleMap]];
        UIImage *btn01Image = [UIImage imageWithData: imageData];
        [btn01 setBackgroundImage:btn01Image forState:UIControlStateNormal];
        [cell addSubview:btn01];
 
        
    } else if (nameArray.count < 2) {
        //無Array
        
        UILabel * cellText = [[UILabel alloc] initWithFrame:CGRectMake([Utility appWidth]*150, [Utility appHeight]*marginHeight, [Utility appWidth]*1010, nouCellHeight - [Utility appHeight]*marginHeight)];
        cellText.text = dataObj.name;
        cellText.textColor = [Utility colorFromHexString:((RADataObject *)item).textColor];
        [cellText setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]];
        cellText.numberOfLines = 0;
        [cell insertSubview:cellText aboveSubview:cellBackGround];
        
//        cell.textLabel.text = ((RADataObject *)item).name;
//        cell.textLabel.textColor = [Utility colorFromHexString:((RADataObject *)item).textColor];
//
//
//        [cell.textLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]];
//        cell.textLabel.numberOfLines = 0;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        //有Array
        NSArray *alignArray = ((RADataObject *)item).columnAlign;
        NSArray *widthArray = ((RADataObject *)item).columnWidth;
        
        CGFloat widthLocation = 0.0;
        CGRect appRect = [[UIScreen mainScreen] bounds];
        CGFloat appWidth = appRect.size.width;
        
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        NSMutableArray *image2Array = [[NSMutableArray alloc]init];
        
        for (int i = 0;i < nameArray.count;i++) {
            
            CGFloat labelWidth = appWidth * ([widthArray[i] floatValue] / 100);
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthLocation, 0.0, labelWidth, 47)];
            [titleLabel setText:nameArray[i]];
            [titleLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]];            
            titleLabel.textColor = [Utility colorFromHexString:((RADataObject *)item).textColor];
            [titleLabel setTextAlignment:[Utility alignTextToNSTextAlignment:alignArray[i]]];
            titleLabel.numberOfLines = 0;
            
            [cell addSubview:titleLabel];
            
    
            widthLocation += labelWidth + 5;
            
            if (i != 0) {
                NSNumber * aNumber = [NSNumber numberWithFloat:widthLocation - 5 - labelWidth];
                [imageArray addObject:aNumber];
                
                NSNumber * bNumber = [NSNumber numberWithFloat:titleLabel.frame.size.height];
                [image2Array addObject:bNumber];
            }
        }
        
        for (int j = 0;j < imageArray.count;j++) {
            CGFloat aWidth = [imageArray[j] floatValue];
            CGFloat bHeight = [image2Array[j] floatValue];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(aWidth, 0.0, 1, bHeight)];
            UIImage *image = [UIImage imageWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"alpha_box_bg" ofType:@"png"]];
            [imageView setImage:image];
            [cell addSubview:imageView];
        }
        
        
    }
    
    //是否有展開icon
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
    [self.ddMenuShowButton setTitle:[ddBUTTON_TEXT objectAtIndex:sender.tag] forState:UIControlStateNormal];
    self.ddMenuShowButton.tag = 0;
    self.ddMenu.hidden = YES;
    
    //查詢參數帶p
    NSString *queryString = [[NSString alloc] initWithFormat:@"%@?p=%@",queryUrl, [ddBUTTON_VALUE objectAtIndex:sender.tag]];
    
    MenuViewController *secondView = [[MenuViewController alloc] init];
    secondView.url = queryString;
    
    [self.navigationController pushViewController:secondView animated:YES];
}

-(CGFloat) countHeight:(NSString *) input {
    //計算欄位高度
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [Utility appWidth]*1010, 0)];
    textLabel.text = input;
    [textLabel setFont:[UIFont fontWithName:@"微軟正黑體" size:[Utility appHeight]*50]];
    textLabel.numberOfLines = 0;
    [textLabel sizeToFit];
    
    CGFloat returnCG = 0.0;
    
    returnCG = textLabel.sizeOfMultiLineLabel.height + 28;
    if (returnCG < 47) {
        returnCG = 47;
    } else {
        returnCG = textLabel.frame.size.height + 47;
    }
    
    return returnCG;
}

-(void)goHome:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)query:(id)sender {
    
    MenuViewController *secondView = [[MenuViewController alloc] init];
    
    //查詢參數帶p
    NSString *queryString = [[NSString alloc] initWithFormat:@"%@?p=%@",queryUrl, inputText.text];
    
    secondView.url = queryString;
    
    [self.navigationController pushViewController:secondView animated:YES];
}
-(void)map:(NouMapButton *)sender{
    MapViewController *nextView = [[MapViewController alloc] init];
    
    nextView.dataObj = sender.dataObj;
    
    [self.navigationController pushViewController:nextView animated:YES];
}
- (IBAction)clearAccount:(id)sender {
    [inputText setText:@""];
}
-(void) errorNetwork {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"網路錯誤"
                                          message:@"是否重新讀取?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"取消", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       [self.navigationController popViewControllerAnimated:NO];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"重新讀取", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   MenuViewController *newVC = [[MenuViewController alloc] init];
                                   newVC.url = self.url;
                                   
                                   NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
                                   [viewControllers removeLastObject];
                                   [viewControllers addObject:newVC];
                                   [[self navigationController] setViewControllers:viewControllers animated:YES];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end

