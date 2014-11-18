//
//  NotificationViewController.h
//  xike
//
//  Created by Leading Chen on 14/11/13.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;


@end
