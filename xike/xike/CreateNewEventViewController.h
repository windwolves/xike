//
//  CreateNewEventViewController.h
//  xike
//
//  Created by Leading Chen on 14-8-31.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "EventInfo.h"
#import "CanlendarView.h"
#import "MonthHeaderView.h"
#import "UserInfo.h"

@protocol CreateNewEventViewControllerDelegate <NSObject>

- (void)didCancelCreateNewEvent;

@end

@interface CreateNewEventViewController : UIViewController <UITextViewDelegate,CanlendarViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MonthHeaderViewDelegate,MonthHeaderViewDatasource, NSURLSessionDataDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) EventInfo *event;
@property (nonatomic, assign) BOOL isCreate;
@property (nonatomic, strong) UserInfo *user;

@end
