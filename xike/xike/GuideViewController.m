//
//  GuideViewController.m
//  xike
//
//  Created by Leading Chen on 14-10-15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "GuideViewController.h"
#import "UserLogonViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    // all settings are basic, pages with custom packgrounds, title image on each page
    [self showIntroWithCrossDissolve];
}

- (void)showIntroWithCrossDissolve {
    GuidePage *page1 = [GuidePage page];
    page1.bgImage = [UIImage imageNamed:@"guide_1.jpg"];
    
    GuidePage *page2 = [GuidePage page];
    page2.bgImage = [UIImage imageNamed:@"guide_2.jpg"];
    
    GuidePage *page3 = [GuidePage page];
    page3.bgImage = [UIImage imageNamed:@"guide_3.jpg"];
    
    GuidePage *page4 = [GuidePage page];
    page4.bgImage = [UIImage imageNamed:@"guide_4.jpg"];
    
    GuideView *guide = [[GuideView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    
    [guide setDelegate:self];
    [guide showInView:self.view animateDuration:0.0];
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
#pragma mark GuideViewDelegate
- (void)guideDidFinish {
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_logonViewController];
    [self presentViewController:navigation animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isGuideShow"];
    }];
}

@end
