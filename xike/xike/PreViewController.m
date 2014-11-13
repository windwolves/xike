//
//  PreViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "PreViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "ImageControl.h"
#import "PeoplePickerViewController.h"
#import "CreateNewEventViewController.h"
#import "MainViewController.h"
#import <MessageUI/MessageUI.h>
#import "ShareEngine.h"



@interface PreViewController ()

@end

@implementation PreViewController {
    UIView *actionBarView;
    UIView *actionView;
    ImageControl *saveCtl;
    ImageControl *sendCtl;
    ImageControl *shareCtl;
    UITapGestureRecognizer *tapGestureRecognizer;
    
}
#define MAIL_SENT @"邮件发送成功"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    actionBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    actionBarView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    
    saveCtl = [[ImageControl alloc] initWithFrame:CGRectMake(92, 5, 24, 36)];
    saveCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_icon_off"] highlightedImage:[UIImage imageNamed:@"save_icon_on"]];
    saveCtl.imageView.frame = CGRectMake(0, 0, 24, 36);
    [saveCtl addSubview:saveCtl.imageView];
    saveCtl.tag = 1;
    [saveCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarView addSubview:saveCtl];
    
    shareCtl = [[ImageControl alloc] initWithFrame:CGRectMake(200, 5, 24, 36)];
    shareCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_icon_off"] highlightedImage:[UIImage imageNamed:@"share_icon_on"]];
    shareCtl.imageView.frame = CGRectMake(0, 0, 24, 36) ;
    [shareCtl addSubview:shareCtl.imageView];
    shareCtl.tag = 2;
    [shareCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarView addSubview:shareCtl];
    
    [self.view addSubview:actionBarView];
    [self buildActionView];
    [actionView removeFromSuperview];
    [ShareEngine sharedInstance].delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [ShareEngine sharedInstance].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"预览"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    if ([_fromController isEqualToString:@"eventsTable"]) {
        UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editEvent)];
        [self.navigationItem setRightBarButtonItem:editBtn];
    }
    
    //_previewWebView.frame = self.view.bounds;
    _previewWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    //_URL = [_URL substringToIndex:([_URL length]-11)];
    _URL = [self generateURLWithEvent:_event];
    [_previewWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
    
    [self.view addSubview:_previewWebView];
    
}

- (void)clickOnCtl:(ImageControl *)sender {
    sender.imageView.highlighted = YES;
    switch (sender.tag) {
        case 1:
            [self saveEvent:_event];
            break;
        case 2:
            [self showAct];
            break;
        default:
            break;
    }
}

- (void)buildActionView {
    actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-269, self.view.bounds.size.width, 269)];
    actionView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    //Share Components' buttons
    // WeChate Session
    UIButton *weChatSessionButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 43, 60, 60)];
    [weChatSessionButton setBackgroundImage:[UIImage imageNamed:@"wechatSession_icon"] forState:UIControlStateNormal];
    [weChatSessionButton addTarget:self action:@selector(wechatSessionShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:weChatSessionButton];
    UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 108, 50, 12)];
    wechatSessionLabel.text = @"微信好友";
    wechatSessionLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:wechatSessionLabel];
    //WeChat Timeline
    UIButton *weChatTimelineButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 43, 60, 60)];
    [weChatTimelineButton setBackgroundImage:[UIImage imageNamed:@"wechatTimeline_icon"] forState:UIControlStateNormal];
    [weChatTimelineButton addTarget:self action:@selector(wechatTimelineShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:weChatTimelineButton];
    UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 108, 60, 12)];
    wechatTimelineLabel.text = @"微信朋友圈";
    wechatTimelineLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:wechatTimelineLabel];
    //Sina Weibo
    UIButton *sinaWeiboButton = [[UIButton alloc] initWithFrame:CGRectMake(223, 43, 60, 60)];
    [sinaWeiboButton setBackgroundImage:[UIImage imageNamed:@"sinaWeibo_icon"] forState:UIControlStateNormal];
    [sinaWeiboButton addTarget:self action:@selector(sinaWeiboShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:sinaWeiboButton];
    UILabel *sinaWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(229, 108, 50, 12)];
    sinaWeiboLabel.text = @"新浪微博";
    sinaWeiboLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:sinaWeiboLabel];
    //SMS
    UIButton *sMSButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 130, 60, 60)];
    [sMSButton setBackgroundImage:[UIImage imageNamed:@"sms_icon"] forState:UIControlStateNormal];
    [sMSButton addTarget:self action:@selector(smsShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:sMSButton];
    UILabel *SMSLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 195, 50, 12)];
    SMSLabel.text = @"短信";
    SMSLabel.font = [UIFont systemFontOfSize:12];
    [actionView addSubview:SMSLabel];
    //Email
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 130, 60, 60)];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"email_icon"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(emailShare) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:emailButton];
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 195, 50, 12)];
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
        shareCtl.imageView.highlighted = NO;
    }];
}

#pragma mark Share Button Actions
- (void)wechatSessionShare {
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneSession :@"和喜欢的人，做喜欢的事。 from 稀客邀请函" :_event.content :[UIImage imageNamed:@"logo_120"] :[NSURL URLWithString:_URL]];
    //[[ShareEngine sharedInstance] sendLinkContent:WXSceneSession :@"中路资本投融资晚宴邀请函" :@"我们诚邀您加入这场创业者和投资人的交流的盛宴" :[UIImage imageNamed:@"zhonglu"] :[NSURL URLWithString:_URL]];
}

- (void)wechatTimelineShare {
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneTimeline :@"和喜欢的人，做喜欢的事。 from 稀客邀请函" :_event.content :[UIImage imageNamed:@"logo_120"] :[NSURL URLWithString:_URL]];
}

- (void)sinaWeiboShare {
    [[ShareEngine sharedInstance] sendWBLinkeContent:@"和喜欢的人，做喜欢的事。 from 稀客邀请函" :_event.content :[UIImage imageNamed:@"logo_120"] :[NSURL URLWithString:_URL]];
}

- (void)smsShare {
    PeoplePickerViewController *peoplePickerViewController = [[PeoplePickerViewController alloc] init];
    peoplePickerViewController.sendOutContent = [[NSString alloc] initWithFormat:@"%@,%@", @"和喜欢的人，做喜欢的事。 from 稀客邀请函", _URL];
    peoplePickerViewController.delegate = self;
    peoplePickerViewController.event = _event;
    peoplePickerViewController.database = _database;
    [self.navigationController pushViewController:peoplePickerViewController animated:YES];
}

- (void)emailShare {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
        emailViewController.mailComposeDelegate = self;
        [emailViewController setMessageBody:[[NSString alloc] initWithFormat:@"%@,%@", @"和喜欢的人，做喜欢的事。 from 稀客邀请函", _URL] isHTML:YES];
        [self.navigationController presentViewController:emailViewController animated:YES completion:nil];
    } else {
        
    }
}

- (void)saveEvent:(EventInfo *)event {
    if ([_database updateEvent:_event]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存" message:@"保存成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
        //[self uploadEventToServer];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存" message:@"保存失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 2;
        [alertView show];
    }
}

- (void)didShareContent:(BOOL)success {
    if (success) {
        _event.send_status = 1;
        [self saveEvent:_event];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"分享失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 2;
        [alertView show];
    }
}

/*
- (void)sendEvent:(EventInfo *)event {
    PeoplePickerViewController *peoplePickerViewController = [[PeoplePickerViewController alloc] init];
    peoplePickerViewController.sendOutContent = [[NSString alloc] initWithFormat:@"%@,%@", @"和喜欢的人，做喜欢的事。 from 稀客邀请函", _URL];
    peoplePickerViewController.delegate = self;
    peoplePickerViewController.event = _event;
    peoplePickerViewController.database = _database;
    [self.navigationController pushViewController:peoplePickerViewController animated:YES];
}

- (void)shareEvent:(EventInfo *)event {
    //the event shall be created on the server first! then the URL can be finalized.
    NSArray *activity = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"和喜欢的人，做喜欢的事。 from 稀客邀请函",[UIImage imageNamed:@"logo_120"],[NSURL URLWithString:_URL]] applicationActivities:activity];
    [self presentViewController:activityView animated:YES completion:^{
        shareCtl.imageView.highlighted = NO;
    // save the event
        _event.send_status = 1;
        [self uploadEventToServer];
        [_database updateEvent:_event];
    }];//it will be save as sent status even the event would not be sent eventually.
}
*/
- (void)editEvent {
    CreateNewEventViewController *modifyEventContorller = [CreateNewEventViewController new];
    modifyEventContorller.database = _database;
    modifyEventContorller.event = _event;
    modifyEventContorller.isCreate = NO;
    [self.navigationController pushViewController:modifyEventContorller animated:YES];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadEventToServer {
    NSString *sendEventService = @"/services/activity/send";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,sendEventService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",_event.uuid];
    
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@",IDString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
}

#pragma private method to generate url parameters
- (NSString *)generateURLWithEvent:(EventInfo *)event {
    //NSString *path = @"http://121.40.139.180:8081/#/activity/";
    NSString *path = [[NSString alloc] initWithFormat:@"%@/#/activity/",HOST];
    NSString *uuid = event.uuid;
    /*
    NSString *userString = [[NSString alloc] initWithFormat:@"user={\"nickname\":\"%@\"}",event.host.name];
    NSString *templateString = [[NSString alloc] initWithFormat:@"template={\"name\":\"%@\"}",event.templateID];
    NSString *titleString = [[NSString alloc] initWithFormat:@"title=%@",event.theme];
    NSString *contentString = [[NSString alloc] initWithFormat:@"content=%@",event.content];
    NSString *timeString = [[NSString alloc] initWithFormat:@"time=%@ %@",event.date,event.time];
    NSString *placeString = [[NSString alloc] initWithFormat:@"place=%@",event.location];
    NSString *parameterString = [[[NSString alloc] initWithFormat:@"%@&%@&%@&%@&%@&%@",userString,templateString,titleString,contentString,timeString,placeString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    */
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",path,uuid];
    return urlString;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AlertView Action
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        saveCtl.imageView.highlighted = NO;
       // [self.navigationController popToRootViewControllerAnimated:YES];

        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MainViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
    } else if (alertView.tag == 2) {
        saveCtl.imageView.highlighted = NO;
    } else if (alertView.tag == 3) {
        [self DidSendEvent:_event];
    } else {
        [self dismissAct]; //dismiss actionView
    }

}

#pragma mark PeoplePickerViewDelegate
- (void)DidSendEvent:(EventInfo *)event {
    sendCtl.imageView.highlighted = NO;
    _event.send_status = 1;
    [_database updateEvent:_event];
    [self uploadEventToServer];
    //[self.navigationController popToRootViewControllerAnimated:YES];

    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[MainViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }

}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    if ([message  isEqual: MAIL_SENT]) {
        alertView.tag = 3;
    }
    [alertView show];
}

#pragma UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

#pragma MFMailComposeViewControllDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self showAlertView:@"邮件发送取消"];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            [self showAlertView:@"邮件被保存"];
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [self showAlertView:@"邮件发送成功"];
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
