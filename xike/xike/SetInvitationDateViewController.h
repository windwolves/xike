//
//  SetInvitationDateViewController.h
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthHeaderView.h"
#import "CanlendarView.h"
#import "EventInfo.h"

@protocol SetInvitationDateViewControllerDelegate <NSObject>
- (void)didFinishSetDate:(EventInfo *)event;

@end

@interface SetInvitationDateViewController : UIViewController <MonthHeaderViewDatasource,MonthHeaderViewDelegate,CanlendarViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) id <SetInvitationDateViewControllerDelegate> delegate;
@property (nonatomic, strong) EventInfo *event;

@end
