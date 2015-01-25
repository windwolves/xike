//
//  CreateGreetingCardViewController.h
//  xike
//
//  Created by Leading Chen on 14/12/11.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateInfo.h"
#import "GreetingInfo.h"
#import "UserInfo.h"
#import "XikeDatabase.h"
#import "FastInpuGreetingWordsViewController.h"

@interface CreateGreetingCardViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate, NSURLSessionDataDelegate, FastInpuGreetingWordsViewControllerDelegate>
@property (nonatomic, strong) TemplateInfo *template;
@property (nonatomic, strong) NSString *receiever;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) GreetingInfo *greeting;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, assign) BOOL isCreate;

@end
