//
//  PreViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "PreViewController.h"
#import "ColorHandler.h"
#import "ImageControl.h"
#import "WeixinSessionActivity.h"
#import "WeixinTimelineActivity.h"
#import "PeoplePickerViewController.h"
#import "CreateNewEventViewController.h"
#import "MainViewController.h"

@interface PreViewController ()

@end

@implementation PreViewController {
    UIView *actionBarView;
    ImageControl *saveCtl;
    ImageControl *sendCtl;
    ImageControl *shareCtl;
    
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
    actionBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    actionBarView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    
    saveCtl = [[ImageControl alloc] initWithFrame:CGRectMake(54, 5, 24, 36)];
    saveCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save_icon_off"] highlightedImage:[UIImage imageNamed:@"save_icon_on"]];
    saveCtl.imageView.frame = CGRectMake(0, 0, 24, 36);
    [saveCtl addSubview:saveCtl.imageView];
    saveCtl.tag = 1;
    [saveCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarView addSubview:saveCtl];
    
    sendCtl = [[ImageControl alloc] initWithFrame:CGRectMake(148, 5, 24, 36)];
    sendCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send_icon_off"] highlightedImage:[UIImage imageNamed:@"send_icon_on"]];
    sendCtl.imageView.frame = CGRectMake(0, 0, 24, 36);
    [sendCtl addSubview:sendCtl.imageView];
    sendCtl.tag = 2;
    [sendCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarView addSubview:sendCtl];
    
    shareCtl = [[ImageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-54-24, 5, 24, 36)];
    shareCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_icon_off"] highlightedImage:[UIImage imageNamed:@"share_icon_on"]];
    shareCtl.imageView.frame = CGRectMake(0, 0, 24, 36) ;
    [shareCtl addSubview:shareCtl.imageView];
    shareCtl.tag = 3;
    [shareCtl addTarget:self action:@selector(clickOnCtl:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarView addSubview:shareCtl];
    
    [self.view addSubview:actionBarView];
}

- (void)clickOnCtl:(ImageControl *)sender {
    sender.imageView.highlighted = YES;
    switch (sender.tag) {
        case 1:
            [self saveEvent:_event];
            break;
        case 2:
            [self sendEvent:_event];
            break;
        case 3:
            [self shareEvent:_event];
            break;
        default:
            break;
    }
}

- (void)saveEvent:(EventInfo *)event {
    if ([_database updateEvent:_event]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存" message:@"保存成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"朕知道了", nil];
        alertView.tag = 1;
        [alertView show];
        [self uploadEventToServer];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存" message:@"保存失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"朕知道了", nil];
        alertView.tag = 2;
        [alertView show];
    }
    
}

- (void)sendEvent:(EventInfo *)event {
    PeoplePickerViewController *peoplePickerViewController = [[PeoplePickerViewController alloc] init];
    peoplePickerViewController.sendOutContent = [[NSString alloc] initWithFormat:@"%@,%@", @"Welcome to Xike!", _URL];
    peoplePickerViewController.delegate = self;
    peoplePickerViewController.event = _event;
    peoplePickerViewController.database = _database;
    [self.navigationController pushViewController:peoplePickerViewController animated:YES];
}

- (void)shareEvent:(EventInfo *)event {
    //the event shall be created on the server first! then the URL can be finalized.
    NSArray *activity = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[@"Welcome to Xike!",[NSURL URLWithString:_URL]] applicationActivities:activity];
    [self presentViewController:activityView animated:YES completion:^{
        shareCtl.imageView.highlighted = NO;
         [self uploadEventToServer];
    }];
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
    _previewWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *a = [_URL substringToIndex:([_URL length]-11)];
    if ([_fromController isEqualToString:@"eventsTable"]) {
        _URL = [self generateURLWithEvent:_event];
        [_previewWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
    } else {
        [_previewWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:a]]];
        NSLog(@"%@",a);
    }
    [self.view addSubview:_previewWebView];

}

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
    
}

#pragma private method to generate url parameters
- (NSString *)generateURLWithEvent:(EventInfo *)event {
    NSString *path = @"http://121.40.139.180:8081/#/activity/?";
    NSString *userString = [[NSString alloc] initWithFormat:@"user={\"nickname\":\"%@\"}",event.host.name];
    NSString *templateString = [[NSString alloc] initWithFormat:@"template={\"name\":\"%@\"}",event.templateID];
    NSString *titleString = [[NSString alloc] initWithFormat:@"title=%@",event.theme];
    NSString *contentString = [[NSString alloc] initWithFormat:@"content=%@",event.content];
    NSString *timeString = [[NSString alloc] initWithFormat:@"time=%@ %@:00",event.date,event.time];
    NSString *placeString = [[NSString alloc] initWithFormat:@"place=%@",event.location];
    NSString *parameterString = [[[NSString alloc] initWithFormat:@"%@&%@&%@&%@&%@&%@",userString,templateString,titleString,contentString,timeString,placeString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",path,parameterString];
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

#pragma UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
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
