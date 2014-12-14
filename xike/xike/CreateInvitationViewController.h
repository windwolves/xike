//
//  CreateInvitationViewController.h
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetInvitationLocationViewController.h"
#import "SetInvitationDateViewController.h"
#import "EventInfo.h"
#import "XikeDatabase.h"
#import "TemplateInfo.h"
#import "UserInfo.h"


@interface CreateInvitationViewController : UIViewController <UITextViewDelegate, SetInvitationLocationViewControllerDelegate, SetInvitationDateViewControllerDelegate,NSURLSessionDataDelegate>
@property (nonatomic, strong) EventInfo *event;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) TemplateInfo *template;
@property (nonatomic, assign) BOOL isCreate;

@end
