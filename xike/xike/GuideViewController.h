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
#import "MainViewController.h"


enum Destination {
    
    Destination_logon  = 0,
    Destination_main = 1,
};

@interface GuideViewController : UIViewController <GuideViewDelegate>
@property (nonatomic, strong) UserLogonViewController *logonViewController;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, assign) NSInteger destination;

@end
