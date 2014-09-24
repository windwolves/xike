//
//  ExploreDetailsViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-23.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ExploreDetailsViewController.h"
#import "WeixinSessionActivity.h"
#import "WeixinTimelineActivity.h"

@interface ExploreDetailsViewController ()

@end

@implementation ExploreDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    
    _detailsView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _detailsView.delegate = self;
    [_detailsView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    [self.view addSubview:_detailsView];
}

- (void)returnBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnClicked {
    NSArray *activity = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"Welcome to Xike!",_url] applicationActivities:activity];
    [self presentViewController:activityView animated:YES completion:^{
        
        //[self uploadToServer:_event];
    }];
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

@end
