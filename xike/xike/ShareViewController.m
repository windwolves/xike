//
//  ShareViewController.m
//  xike
//
//  Created by Leading Chen on 15/1/25.
//  Copyright (c) 2015年 Leading. All rights reserved.
//

#import "ShareViewController.h"
#import "ColorHandler.h"
#import "MainView2Controller.h"

#define viewWidth self.view.bounds.size.width
#define viewHeight self.view.bounds.size.height
@interface ShareViewController ()

@end

@implementation ShareViewController {
    ImageControl *returnBtn;
    ImageControl *backToHomeBtn;
    UIView *navigationBar;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self buildNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    self.navigationController.navigationBarHidden = YES;
    
    
    [self buildContentView];
}

- (void)buildNavigationBar {
    if (navigationBar) {
        [navigationBar removeFromSuperview];
    } else {
        navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
        navigationBar.backgroundColor= [ColorHandler colorWithHexString:@"#1de9b6"];
        [self.view addSubview:navigationBar];
        
        returnBtn = [[ImageControl alloc] initWithFrame:CGRectMake(10, 33, 43, 18)];
        returnBtn.imageView = [[UIImageView alloc] initWithFrame:returnBtn.bounds];
        returnBtn.imageView.image = [UIImage imageNamed:@"return_icon"];
        [returnBtn addSubview:returnBtn.imageView];
        [returnBtn addTarget:self action:@selector(returnToPreviousView) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:returnBtn];
        
        backToHomeBtn = [[ImageControl alloc] initWithFrame:CGRectMake(viewWidth-53, 33, 43, 18)];
        backToHomeBtn.imageView = [[UIImageView alloc] initWithFrame:backToHomeBtn.bounds];
        backToHomeBtn.imageView.image = [UIImage imageNamed:@"back_to_home_icon"];
        [backToHomeBtn addSubview:backToHomeBtn.imageView];
        [backToHomeBtn addTarget:self action:@selector(backToHomePage) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:backToHomeBtn];
        
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-85)/2, 33, 85, 18)];
        titleView.image = [UIImage imageNamed:@"share_title"];
        [navigationBar addSubview:titleView];
    }
    
    [self.view addSubview:navigationBar];
}

- (void)buildContentView {
    UIImageView *savedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-145)/2, 90, 145, 18)];
    savedImageView.image = [UIImage imageNamed:@"already_saved"];
    [self.view addSubview:savedImageView];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth-80)/2, 153, 80, 15)];
    shareLabel.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
    shareLabel.font = [UIFont systemFontOfSize:15];
    shareLabel.text = @"分享发送至";
    [self.view addSubview:shareLabel];
    
    //Share Components' buttons
    //WeChat Timeline
    UIButton *weChatTimelineButton = [[UIButton alloc] initWithFrame:CGRectMake(43, 183, 50, 50)];
    [weChatTimelineButton setBackgroundImage:[UIImage imageNamed:@"wechatTimeline_icon"] forState:UIControlStateNormal];
    [weChatTimelineButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    weChatTimelineButton.tag = WXTimeLine;
    [self.view addSubview:weChatTimelineButton];
    UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 245, 45, 15)];
    wechatTimelineLabel.text = @"朋友圈";
    wechatTimelineLabel.textColor = [ColorHandler colorWithHexString:@"#a9a9a9"];
    wechatTimelineLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:wechatTimelineLabel];
    // WeChate Session
    UIButton *weChatSessionButton = [[UIButton alloc] initWithFrame:CGRectMake(134, 183, 50, 50)];
    [weChatSessionButton setBackgroundImage:[UIImage imageNamed:@"wechatSession_icon"] forState:UIControlStateNormal];
    [weChatSessionButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    weChatSessionButton.tag = WXSession;
    [self.view addSubview:weChatSessionButton];
    UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 245, 60, 15)];
    wechatSessionLabel.text = @"微信好友";
    wechatSessionLabel.textColor = [ColorHandler colorWithHexString:@"#a9a9a9"];
    wechatSessionLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:wechatSessionLabel];
    //Email
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(225, 183, 50, 50)];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"email_icon"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    emailButton.tag = Email;
    [self.view addSubview:emailButton];
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(236, 245, 60, 15)];
    emailLabel.text = @"邮件";
    emailLabel.textColor = [ColorHandler colorWithHexString:@"#a9a9a9"];
    emailLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:emailLabel];
    //Sina Weibo
    UIButton *sinaWeiboButton = [[UIButton alloc] initWithFrame:CGRectMake(43, 275, 50, 50)];
    [sinaWeiboButton setBackgroundImage:[UIImage imageNamed:@"sinaWeibo_icon"] forState:UIControlStateNormal];
    [sinaWeiboButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    sinaWeiboButton.tag = SinaWB;
    [self.view addSubview:sinaWeiboButton];
    UILabel *sinaWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 337, 60, 15)];
    sinaWeiboLabel.text = @"新浪微博";
    sinaWeiboLabel.textColor = [ColorHandler colorWithHexString:@"#a9a9a9"];
    sinaWeiboLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sinaWeiboLabel];
    //SMS
    UIButton *sMSButton = [[UIButton alloc] initWithFrame:CGRectMake(134, 275, 50, 50)];
    [sMSButton setBackgroundImage:[UIImage imageNamed:@"sms_icon"] forState:UIControlStateNormal];
    [sMSButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    sMSButton.tag = SMS;
    [self.view addSubview:sMSButton];
    UILabel *SMSLabel = [[UILabel alloc] initWithFrame:CGRectMake(146, 337, 30, 15)];
    SMSLabel.text = @"短信";
    SMSLabel.textColor = [ColorHandler colorWithHexString:@"#a9a9a9"];
    SMSLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:SMSLabel];
    
}

- (void)clickOnButton:(UIButton *)button {
    if (button.tag == WXTimeLine) {
        [self.delegate share:WXTimeLine];
    } else if (button.tag == WXSession) {
        [self.delegate share:WXSession];
    } else if (button.tag == Email) {
        [self.delegate share:Email];
    } else if (button.tag == SinaWB) {
        [self.delegate share:SinaWB];
    } else if (button.tag == SMS) {
        [self.delegate share:SMS];
    }
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToHomePage {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[MainView2Controller class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
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

@end
