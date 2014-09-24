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
    _exploreView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    NSString *urlString = @"http://121.40.139.180:8081/#/discover/list";
    [_exploreView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    _exploreView.delegate = self;
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
    [self.view addSubview:_exploreView];
}

@end
