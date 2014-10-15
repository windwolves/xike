//
//  GuideViewController.h
//  xike
//
//  Created by Leading Chen on 14-10-15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideView.h"
#import "XikeDatabase.h"
#import "UserLogonViewController.h"

@interface GuideViewController : UIViewController <GuideViewDelegate>
@property (nonatomic, strong) UserLogonViewController *logonViewController;
@property (nonatomic, strong) XikeDatabase *database;
@property (strong, nonatomic) NSString *deviceToken;

@end
