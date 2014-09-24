//
//  SettingViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "SettingViewController.h"
#import "ColorHandler.h"
#import "AccountSettingViewController.h"
#import "AboutUSViewController.h"
#import "SuggestionViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(155/2-30, 102-64, 60, 100)];
    logoImageView.image = [UIImage imageNamed:@"logo_setting"];
    [self.view addSubview:logoImageView];
    
    UIControl *accountSettingCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 260-64, 155, 46)];
    UIImageView *accountSettingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(155/2-24, 0, 47.5, 46)];
    accountSettingImageView.image = [UIImage imageNamed:@"accountSetting_icon"];
    UILabel *accountSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 155, 12)];
    accountSettingLabel.textAlignment = NSTextAlignmentCenter;
    accountSettingLabel.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
    accountSettingLabel.font = [UIFont systemFontOfSize:12];
    accountSettingLabel.text = @"个人设置";
    accountSettingCtl.tag = 1;
    [accountSettingCtl addSubview:accountSettingImageView];
    //[accountSettingCtl addSubview:accountSettingLabel];
    [accountSettingCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountSettingCtl];
    
    UIControl *aboutUSCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 350-64, 155, 46)];
    UIImageView *aboutUSImageView = [[UIImageView alloc] initWithFrame:CGRectMake(155/2-24, 0, 47.5, 46)];
    aboutUSImageView.image = [UIImage imageNamed:@"aboutUS_icon"];
    UILabel *aboutUSLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 155, 12)];
    aboutUSLabel.textAlignment = NSTextAlignmentCenter;
    aboutUSLabel.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
    aboutUSLabel.font = [UIFont systemFontOfSize:12];
    aboutUSLabel.text = @"关于我们";
    aboutUSCtl.tag = 2;
    [aboutUSCtl addSubview:aboutUSImageView];
    //[aboutUSCtl addSubview:aboutUSLabel];
    [aboutUSCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutUSCtl];
    
    UIControl *suggestionCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 440-64, 155, 46)];
    UIImageView *suggestionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(155/2-24, 0, 47, 43)];
    suggestionImageView.image = [UIImage imageNamed:@"suggestion_icon"];
    suggestionCtl.tag = 3;
    [suggestionCtl addSubview:suggestionImageView];
    [suggestionCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suggestionCtl];
}

- (void)clickOnCtl:(UIControl *)sender {
    if (sender.tag == 1) {
        AccountSettingViewController *accountSettingViewController = [AccountSettingViewController new];
        accountSettingViewController.delegate = self;
        accountSettingViewController.database = _database;
        accountSettingViewController.user = _user;
        [self.navigationController pushViewController:accountSettingViewController animated:YES];
    } else if (sender.tag == 2) {
        AboutUSViewController *aboutUSViewController = [AboutUSViewController new];
        [self.navigationController pushViewController:aboutUSViewController animated:YES];
    } else if (sender.tag == 3) {
        SuggestionViewController *suggestionViewController = [SuggestionViewController new];
        suggestionViewController.user = _user;
        [self.navigationController pushViewController:suggestionViewController animated:YES];
    }
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

#pragma AccountSettingViewControllerDelegate
- (void)didFinishAccountSettingwith:(UserInfo *)user {
    [self.delegate changeUserInfo:user];
}

@end
