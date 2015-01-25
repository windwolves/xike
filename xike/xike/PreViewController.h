//
//  PreViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInfo.h"
#import "XikeDatabase.h"
#import "PeoplePickerViewController.h"
#import <MessageUI/MessageUI.h>
#import "ShareEngine.h"
#import "GreetingInfo.h"
#import "ShareViewController.h"

@interface PreViewController : UIViewController <PeoplePickerViewControllerDelegate, UIWebViewDelegate,NSURLSessionDataDelegate,MFMailComposeViewControllerDelegate,ShareEngineDelegate,ShareViewControllerDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) EventInfo *event;
@property (nonatomic, strong) GreetingInfo *greeting;
@property (nonatomic, strong) UIWebView *previewWebView;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *fromController;
@property (nonatomic, strong) NSString *createItem;
@end
