//
//  EventCell.h
//  xike
//
//  Created by Leading Chen on 14-9-12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInfo.h"

@interface EventCell : UIControl
@property (nonatomic, strong) UIImageView *tempalteImageView;
@property (nonatomic, strong) UILabel *yearMonthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekdayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *locationLaebl;
@property (nonatomic, strong) EventInfo *event;

- (id)initWithFrame:(CGRect)frame Event:(EventInfo *)event;
@end
