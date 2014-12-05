//
//  ViewController.m
//  nou
//
//  Created by Ken on 2014/10/30.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
//NSDictionary *resultJSON
@property (strong, nonatomic) NSDictionary *resultJSON;

@end

@implementation ViewController
@synthesize resultJSON,detailChildArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"RootView"];
    /*
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 30, 10)];
    [btn setFrame:CGRectMake(0, 0, 30, 10)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickMeAction:) forControlEvents:UIControlEventTouchUpInside];
    */
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(clickMeAction:)];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"http://210.80.86.180:8081/nouWeb/index?ACCOUNT=100100362"];
    
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc] init];
    
    [urlrequest setTimeoutInterval:20];
    
    [urlrequest setURL:[NSURL URLWithString:urlString]];
    
    
    
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:urlrequest
                    
                                         returningResponse:&response
                    
                                                     error:&error];
    
    if (data != nil) {
        
        
        
//        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
//    NSLog(@"test>>>>%zd",[[resultJSON objectForKey:@"MENU"] length]);
//        NSLog(@"test>>>>%tu",[[resultJSON objectForKey:@"MENU"] length]);
/*    for(NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        <#statements#>
    }
 */
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    for(NSDictionary *menuDic in menuArray) {
        NSLog(@"%@", [menuDic objectForKey:@"NAME"]);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickMeAction:(id)sender

{
    
    UIViewController *sec=[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    
    [self.navigationController pushViewController:sec animated:YES];
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There is only one section.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of time zone names.
//    return [timeZoneNames count];
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    return [menuArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    // Set up the cell.
//    NSString *timeZoneName = [timeZoneNames objectAtIndex:indexPath.row];
//    cell.textLabel.text = timeZoneName;
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];

    NSDictionary *menu = [menuArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [menu objectForKey:@"NAME"];
//    [cell ad]
    NSArray *detailArray = [menu objectForKey:@"DETAIL"];
    NSLog(@"%zd",detailArray.count);
    NSMutableArray *childMArray = [[NSMutableArray alloc] init];

    if (detailArray.count > 0) {
//        NSArray *detailChildArray = [NSArray array];
        for(NSDictionary *detailChild in detailArray){
//            NSLog(@"%@",[detailChild objectForKey:@"NAME"]);
            NSString *nameStr = [detailChild objectForKey:@"NAME"];
            nameStr = [nameStr stringByReplacingOccurrencesOfString:@"*" withString:@""];
            [childMArray addObject:nameStr];

        }
        NSLog(@"done");
        detailChildArray = [NSArray arrayWithArray:childMArray];
        for (NSString *name in detailChildArray) {
            NSLog(@"%@",name);
            /*UILabel *subName = [[UILabel alloc] init];
            subName.text = name;
            [cell.contentView addSubview:subName];*/
        }
        
        
        NSMutableArray* insertingRows = [NSMutableArray array];
        for (int i = 0; i < detailChildArray.count; i++) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section];
            [insertingRows addObject:newIndexPath];
        }
        /*
        if (detailChildArray.count >0) {
         
            [self.tableView beginUpdates];
//            [self.tableView insertRowsAtIndexPaths:insertingRows withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }*/
        
    }
    return cell;
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


//当cell被选择（被点击）时调用的函数
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    
    NSDictionary *menu = [menuArray objectAtIndex:indexPath.row];

    //    [cell ad]
    NSArray *detailArray = [menu objectForKey:@"DETAIL"];
    NSLog(@"%zd",detailArray.count);
    NSMutableArray *indexPathSet = [[NSMutableArray alloc] init];
    if (detailArray.count > 0) {
        NSArray *detailChildArray = [NSArray array];
        for(NSDictionary *detailChild in detailArray){
            NSLog(@"%@",[detailChild objectForKey:@"NAME"]);
            [detailChildArray arrayByAddingObject:[detailChild objectForKey:@"NAME"]];
        }
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:detailChildArray withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
    }
/*
//    TableCell *cell=[_TableArry objectAtIndex:indexPath.row];
    NSArray *menuArray = [resultJSON valueForKey:@"MENU"];
    NSDictionary *childMenu = [menuArray objectAtIndex:indexPath.row];
//    NSLog(@"%d",indexPath.row);
    NSArray *detailArray = [childMenu objectForKey:@"DETAIL"];

    if(detailArray.count==0)//如果没有子菜单
    {
        NSLog(@"要打开页面");
    }
    else
    {
        if(!cell.Open)//如果子菜单是关闭的
        {
            NSArray * array =  [self insertOperation:cell];
            if(array.count>0)
                //从视图中添加
                [tableView insertRowsAtIndexPaths: array withRowAnimation:UITableViewRowAnimationBottom ];
            
        }
        else//如果子菜单是打开的
        {
            NSArray * array = [self deleteOperation:cell];
            if(array.count>0)
                //从视图中删除
                [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
        }
    }*/
}



@end
