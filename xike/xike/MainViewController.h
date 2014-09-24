//
//  MainViewController.h
//  xike
//
//  Created by Leading Chen on 14-8-27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"
#import "SettingViewController.h"
#import "TabbarView.h"
#import "CreateNewEventViewController.h"

@interface MainViewController : UIViewController <SettingViewControllerDelegate,TabbarViewDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;

@end
