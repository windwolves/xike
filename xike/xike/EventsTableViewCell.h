//
//  EventsTableViewCell.h
//  xike
//
//  Created by Leading Chen on 14-9-17.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInfo.h"
#import "TemplateInfo.h"

@class EventsTableViewCell;
@protocol EventsTableViewCellDelegate <NSObject>

- (TemplateInfo *)getTemplateByID:(NSString *)templateID;

@end

@interface EventsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *tempalteImageView;
@property (nonatomic, strong) UILabel *yearMonthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekdayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *locationLaebl;
@property (nonatomic, strong) EventInfo *event;
@property (nonatomic, strong) id <EventsTableViewCellDelegate> delegate;

- (void)setEvent:(EventInfo *)event;
@end
