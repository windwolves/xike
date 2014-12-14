//
//  GuideViewController.m
//  xike
//
//  Created by Leading Chen on 14-10-15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "GuideViewController.h"
#import "UserLogonViewController.h"
#import "ImageScrollView.h"
#import "Contants.h"

@interface GuideViewController ()

@end

@implementation GuideViewController {
    ImageScrollView *guideView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    // all settings are basic, pages with custom packgrounds, title image on each page
    [self showIntroWithCrossDissolve];
    //[self buildGuideView];
}

- (void)buildGuideView {
    guideView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage *guide_1 = [UIImage imageNamed:@"guide_1.jpg"];
    UIImage *guide_2 = [UIImage imageNamed:@"guide_2.jpg"];
    UIImage *guide_3 = [UIImage imageNamed:@"guide_3.jpg"];
    UIImage *guide_4 = [UIImage imageNamed:@"guide_4.jpg"];
    UIImage *guide_5 = [UIImage imageNamed:@"guide_5.jpg"];
    [guideView initializeWith:@[guide_1,guide_2,guide_3,guide_4,guide_5]];
    [guideView setAutoScroll:NO];
    [self.view addSubview:guideView];
}

- (void)showIntroWithCrossDissolve {
    GuidePage *page1 = [GuidePage page];
    page1.bgImage = [UIImage imageNamed:@"guide_1"];
    
    GuidePage *page2 = [GuidePage page];
    page2.bgImage = [UIImage imageNamed:@"guide_2"];
    
    GuidePage *page3 = [GuidePage page];
    page3.bgImage = [UIImage imageNamed:@"guide_3"];
    
    GuidePage *page4 = [GuidePage page];
    page4.bgImage = [UIImage imageNamed:@"guide_4"];
    
    GuidePage *page5 = [GuidePage page];
    page5.bgImage = [UIImage imageNamed:@"guide_5"];
    
    GuideView *guide = [[GuideView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
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
    if (_destination == Destination_logon) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_logonViewController];
        [self presentViewController:navigation animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setFloat:app_version forKey:@"version"];
        }];
    } else if (_destination == Destination_main) {
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_mainView2Controller];
        [self presentViewController:navigation animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setFloat:app_version forKey:@"version"];
        }];
    }
}

@end
