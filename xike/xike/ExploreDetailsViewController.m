//
//  ExploreDetailsViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-23.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ExploreDetailsViewController.h"
#import "ColorHandler.h"
#import "ShareEngine.h"
#import "PeoplePickerViewController.h"

@interface ExploreDetailsViewController () {

}

@end

@implementation ExploreDetailsViewController {
    UIView *actionView;
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
    [self buildActionView];
    [actionView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    shareBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    
    _detailsView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _detailsView.delegate = self;
    [_detailsView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    //[self.view addSubview:_detailsView];
}

- (void)returnBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnClicked {
    [self showAct];
}

- (void)DidSendEvent:(EventInfo *)event {
    
}

- (void)buildActionView {
    actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-269, self.view.bounds.size.width, 269)];
    actionView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    //Share Components' buttons
    // WeChate Session
    UIButton *weChatSessionButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 30, 60, 60)];
    [weChatSessionButton setBackgroundImage:[UIImage imageNamed:@"wechatSession_icon"] forState:UIControlStateNormal];
    [weChatSessionButton addTarget:self action:@selector(wechatSessionShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:weChatSessionButton];
    UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 94, 50, 12)];
    wechatSessionLabel.text = @"微信好友";
    wechatSessionLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:wechatSessionLabel];
    //WeChat Timeline
    UIButton *weChatTimelineButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 30, 60, 60)];
    [weChatTimelineButton setBackgroundImage:[UIImage imageNamed:@"wechatTimeline_icon"] forState:UIControlStateNormal];
    [weChatTimelineButton addTarget:self action:@selector(wechatTimelineShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:weChatTimelineButton];
    UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 94, 60, 12)];
    wechatTimelineLabel.text = @"微信朋友圈";
    wechatTimelineLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:wechatTimelineLabel];
    //Sina Weibo
    UIButton *sinaWeiboButton = [[UIButton alloc] initWithFrame:CGRectMake(223, 30, 60, 60)];
    [sinaWeiboButton setBackgroundImage:[UIImage imageNamed:@"sinaWeibo_icon"] forState:UIControlStateNormal];
    [sinaWeiboButton addTarget:self action:@selector(sinaWeiboShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:sinaWeiboButton];
    UILabel *sinaWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(229, 94, 50, 12)];
    sinaWeiboLabel.text = @"新浪微博";
    sinaWeiboLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:sinaWeiboLabel];
    //SMS
    UIButton *sMSButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 115, 60, 60)];
    [sMSButton setBackgroundImage:[UIImage imageNamed:@"sms_icon"] forState:UIControlStateNormal];
    [sMSButton addTarget:self action:@selector(smsShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:sMSButton];
    UILabel *SMSLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 180, 50, 12)];
    SMSLabel.text = @"短信";
    SMSLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:SMSLabel];
    //Email
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 115, 60, 60)];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"email_icon"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(emailShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:emailButton];
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 180, 50, 12)];
    emailLabel.text = @"邮件";
    emailLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:emailLabel];
    //Cancel
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, actionView.bounds.size.height-49, actionView.bounds.size.width, 0.5)];
    lineImageView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    [actionView addSubview:lineImageView];
    UIControl *cancelCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, actionView.bounds.size.height-50, actionView.bounds.size.width, 49)];
    [cancelCtl addTarget:self action:@selector(dismissAct) forControlEvents:UIControlEventTouchUpInside];
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cancelCtl.bounds.size.width, cancelCtl.bounds.size.height)];
    cancelLabel.text = @"取消";
    cancelLabel.font = [UIFont systemFontOfSize:23];
    cancelLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    [cancelCtl addSubview:cancelLabel];
    [actionView addSubview:cancelCtl];
    
}

- (void)showAct {
    
    [self.view addSubview:actionView];
    //popup animation
    [actionView setTransform:CGAffineTransformMakeTranslation(0, actionView.bounds.size.height)];
    [UIView animateWithDuration:0.5 animations:^{
        [actionView setTransform:CGAffineTransformIdentity];
    }];
}

- (void)dismissAct {
    [UIView animateWithDuration:0.5 animations:^{
        [actionView setTransform:CGAffineTransformMakeTranslation(0, actionView.bounds.size.height)];
    } completion:^(BOOL finished) {
        [actionView removeFromSuperview];
    }];
}

#pragma mark Share Button Actions
- (void)wechatSessionShare {
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneSession :@"和喜欢的人，做喜欢的事。 from 稀客邀请函" :_desc :[UIImage imageNamed:@"logo_120"] :_url];
}

- (void)wechatTimelineShare {
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneTimeline :@"和喜欢的人，做喜欢的事。 from 稀客邀请函" :_desc :[UIImage imageNamed:@"logo_120"] :_url];
}

- (void)sinaWeiboShare {
    [[ShareEngine sharedInstance] sendWBLinkeContent:@"和喜欢的人，做喜欢的事。 from 稀客邀请函" :_desc :[UIImage imageNamed:@"logo_120"] :_url];
    
}

- (void)smsShare {
    PeoplePickerViewController *peoplePickerViewController = [[PeoplePickerViewController alloc] init];
    peoplePickerViewController.sendOutContent = [[NSString alloc] initWithFormat:@"%@,%@", @"和喜欢的人，做喜欢的事。 from 稀客邀请函", _url];
    peoplePickerViewController.delegate = self;
    //peoplePickerViewController.event = _event;
    //peoplePickerViewController.database = _database;
    [self.navigationController pushViewController:peoplePickerViewController animated:YES];
}

- (void)emailShare {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
        emailViewController.mailComposeDelegate = self;
        [emailViewController setMessageBody:[[NSString alloc] initWithFormat:@"%@,%@", @"和喜欢的人，做喜欢的事。 from 稀客邀请函", _url] isHTML:YES];
        [self.navigationController presentViewController:emailViewController animated:YES completion:nil];
    } else {
        
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.view addSubview:_detailsView];
    
}

@end
