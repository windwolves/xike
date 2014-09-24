//
//  ChooseTemplateViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-9.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ChooseTemplateViewController.h"
#import "ColorHandler.h"
#import "ImageControl.h"
#import "PreViewController.h"

@interface ChooseTemplateViewController ()

@end

@implementation ChooseTemplateViewController {
    UIWebView *templateView;
    UITableView *chooseListTableView;
    UIGestureRecognizer *tapGestureRecognizer;
    NSString *URL;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"模板选择"];
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    doneBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    tapGestureRecognizer = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(didChoose:)];
    
    //templateView = [[UIWebView alloc] initWithFrame:CGRectMake(31.5, 3.5, 257, 405)];
    templateView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    templateView.delegate = self;
    //default choose
    _event.templateID = @"x001";
    URL = [self generateURLWithEvent:_event];
    [templateView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    [self.view addSubview:templateView];
    
    chooseListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 420, 320, 81)];
    [self buildChooseList];
    
}

- (void)buildChooseList {
    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    chooseListTableView.transform = rotateTable;
    chooseListTableView.frame = CGRectMake(0, 420, 320, 81);
    chooseListTableView.dataSource = self;
    chooseListTableView.delegate = self;
    chooseListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chooseListTableView.rowHeight = 55;
    [self.view addSubview:chooseListTableView];
}

- (void)reloadData {
    [chooseListTableView reloadData];
}

- (void)didChoose:(ImageControl *)sender {
    _event.templateID = sender.controlID;
    URL = [self generateURLWithEvent:_event];
    [templateView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)next {
    PreViewController *previewController = [PreViewController new];
    previewController.event = _event;
    previewController.database = _database;
    //previewController.previewWebView = templateView;
    previewController.URL = URL;
    [self.navigationController pushViewController:previewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    //TODO
    if ([[cell.contentView subviews] count] > 0) {
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    ImageControl *tempalteCtl = [[ImageControl alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];

    UIImageView *templateSmallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 51, 81)];
    NSString *templateNameString;
    if (indexPath.row+1 < 10) {
        templateNameString = [[NSString alloc] initWithFormat:@"x00%d",indexPath.row+1];
    } else {
        templateNameString = [[NSString alloc] initWithFormat:@"x0%d",indexPath.row+1];
    }

    templateSmallImageView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@.jpg",templateNameString]];
    [tempalteCtl addSubview:templateSmallImageView];
    tempalteCtl.controlID = templateNameString;
    [tempalteCtl addTarget:self action:@selector(didChoose:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:tempalteCtl];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
    cell.transform = rotateTable;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ImageControl *ctl = (ImageControl *)[[cell.contentView subviews] objectAtIndex:0];
    _event.templateID = ctl.controlID;
    NSString *URL = [self generateURLWithEvent:_event];
    [templateView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
*/
}

#pragma private method to generate url parameters
- (NSString *)generateURLWithEvent:(EventInfo *)event {
    NSString *path = @"http://121.40.139.180:8081/#/activity/?";
    NSString *userString = [[NSString alloc] initWithFormat:@"user={\"nickname\":\"%@\"}",event.host.name];
    NSString *templateString = [[NSString alloc] initWithFormat:@"template={\"name\":\"%@\"}",event.templateID];
    NSString *titleString = [[NSString alloc] initWithFormat:@"title=%@",event.theme];
    NSString *contentString = [[NSString alloc] initWithFormat:@"content=%@",event.content];
    NSString *timeString = [[NSString alloc] initWithFormat:@"time=%@ %@:00",event.date,event.time];
    NSString *placeString = [[NSString alloc] initWithFormat:@"place=%@",event.location];
    NSString *modeString = @"mode=scale";
    NSString *parameterString = [[[NSString alloc] initWithFormat:@"%@&%@&%@&%@&%@&%@&%@",userString,templateString,titleString,contentString,timeString,placeString,modeString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",path,parameterString];
    NSLog(@"%@",urlString);
    return urlString;

}

#pragma UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

@end