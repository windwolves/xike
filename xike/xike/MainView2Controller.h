//
//  MainView2Controller.h
//  xike
//
//  Created by Leading Chen on 14/12/1.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"
#import "SettingView2Controller.h"
#import "TabbarView.h"
#import "CreateNewEventViewController.h"
#import "HomePageViewController.h"

@interface MainView2Controller : UIViewController <SettingView2ControllerDelegate,TabbarViewDelegate,HomePageViewDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;

@end
