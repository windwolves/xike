//
//  ExploreViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-31.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ExploreViewController.h"
#import "ExploreDetailsViewController.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

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
    _exploreView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49-64)];
    NSString *urlString = @"http://121.40.139.180:8081/#/discover/list";
    [_exploreView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    _exploreView.delegate = self;
        [self.view addSubview:_exploreView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    UIControl *view1 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, (self.view.bounds.size.height-49)/3)];
    view1.tag = 1;
    [view1 addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    UIControl *view2 = [[UIControl alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height-49)/3, 320, (self.view.bounds.size.height-49)/3)];
    view2.tag = 2;
    [view2 addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    UIControl *view3 = [[UIControl alloc] initWithFrame:CGRectMake(0, 2*(self.view.bounds.size.height-49)/3, 320, (self.view.bounds.size.height-49)/3)];
    view3.tag = 3;
    [view3 addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view3];
    
}

- (void)viewTapped:(UIControl *)view {

    ExploreDetailsViewController *exploreDetailsViewController = [ExploreDetailsViewController new];
    if (view.tag == 1) {
        exploreDetailsViewController.url = [NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/7ce1f331-df82-4c89-a892-038231d7d04d"];
    } else if (view.tag == 2) {
        exploreDetailsViewController.url = [NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/cfbd973f-7c06-4f30-941a-f5656555e1f9"];
    } else if (view.tag == 3) {
        exploreDetailsViewController.url = [NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/cf349ef5-ab85-48ee-a5e9-82b58154af64"];
    }
    
    
    [self.navigationController pushViewController:exploreDetailsViewController animated:YES];

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

#pragma mark WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *URL = [request URL];
        ExploreDetailsViewController *exploreDetailsViewController = [ExploreDetailsViewController new];
        exploreDetailsViewController.url = URL;
        [self.navigationController pushViewController:exploreDetailsViewController animated:YES];
        return NO;
    }
    return YES;
}

- (NSDictionary *)parseURL:(NSURL *)url{
    NSMutableDictionary *paraDictionary = [NSMutableDictionary new];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@", url];
    NSArray *compontent1 = [urlString componentsSeparatedByString:@"?"];
    NSString *parameterString = [compontent1 lastObject];
    NSArray *parameterArray = [parameterString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameterArray) {
        NSArray *keyVal = [parameter componentsSeparatedByString:@"="];
        if (keyVal.count > 0) {
            NSString *paraKey = [keyVal objectAtIndex:0];
            NSString *value = (keyVal.count == 2) ? [keyVal lastObject] : nil;
            [paraDictionary setValue:value forKey:paraKey];
        }
    }
    return paraDictionary;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

@end
