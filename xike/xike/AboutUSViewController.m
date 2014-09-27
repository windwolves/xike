//
//  AboutUSViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-9.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "AboutUSViewController.h"
#import "WeixinSessionActivity.h"
#import "WeixinTimelineActivity.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

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
    [self.navigationItem setTitle:@"关于我们"];
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    shareBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    
    UIImageView *aboutUSImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    aboutUSImageView.image = [UIImage imageNamed:@"aboutUS"];
    [self.view addSubview:aboutUSImageView];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share {
    //TODO
    NSArray *activity = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"我正在稀客和喜欢的人做喜欢的事，快来一起体验吧！",[NSURL URLWithString:@""]] applicationActivities:activity];
    [self presentViewController:activityView animated:YES completion:^{
        
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

@end
