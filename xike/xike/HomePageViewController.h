//
//  HomePageViewController.h
//  NetworkTest
//
//  Created by Leading Chen on 14/11/25.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"
#import "HomeTemplateContentView.h"

@protocol HomePageViewDelegate <NSObject>

- (void)didChangeSection;
- (void)popNotificationView;
- (void)didChooseTemplate:(TemplateInfo *)template;

@end

@interface HomePageViewController : UIViewController <HomeTemplateContentViewDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) id <HomePageViewDelegate> delegate;

@end
