//
//  MyEventsViewController.h
//  xike
//
//  Created by Leading Chen on 14-8-31.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "XikeDatabase.h"
#import "SettingViewController.h"
#import "EventsTableViewCell.h"

@interface MyEventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,EventsTableViewCellDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UITableView *eventsTable;

@end
