//
//  CanlendarView.m
//  xike
//
//  Created by Leading Chen on 14-9-2.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CanlendarView.h"
#import "ColorHandler.h"
#import "ImageControl.h"

@implementation CanlendarView

- (id)initWithFrame:(CGRect)frame withMonth:(NSDateComponents *)month {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _month = month;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    //get current
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYYMMdd"];
    _dateSelected = [formatter stringFromDate:[NSDate date]];
    
    [self createDaysButton];
    
}


- (void)createDaysButton {
    //remove all the subviews at first so that we can re-draw on a clean view.
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger const numberOfDaysPerWeek = 7;
    float const daysButtonWidth = self.bounds.size.width/7;
    float const daysButtonHeight = self.bounds.size.height/5;
    
    NSDateComponents *day = [[NSDateComponents alloc] init];
    day.calendar = self.month.calendar;
    day.day = 1;
    day.month = self.month.month;
    day.year = self.month.year;
    
    NSDate *firstDate = [day.calendar dateFromComponents:day];
    day = [_month.calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:firstDate];
    NSInteger numberOfDaysInMonth = [day.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[day date]].length;
    
    NSInteger startColumn = day.weekday - day.calendar.firstWeekday;
    CGPoint nextDayViewOrigin = CGPointZero;
    nextDayViewOrigin.x = daysButtonWidth * startColumn;
    
    do {
        for (NSInteger column = startColumn; column < numberOfDaysPerWeek; column++) {
            if (day.day <= numberOfDaysInMonth) {
                CGRect dayFrame = CGRectZero;
                dayFrame.origin = nextDayViewOrigin;
                dayFrame.size.width = daysButtonWidth;
                dayFrame.size.height = daysButtonHeight;
                NSString *titleText = [NSString stringWithFormat:@"%d", (NSInteger)day.day];
                if (day.day == [[_dateSelected substringWithRange:NSMakeRange(6, 2)] integerValue]) {
                    ImageControl *dayCtl = [[ImageControl alloc] initWithFrame:dayFrame];
                    dayCtl.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((dayCtl.bounds.size.width-45/2)/2, (dayCtl.bounds.size.height-45/2)/2, 45/2, 45/2)];
                    dayCtl.imageView.layer.cornerRadius = CGRectGetHeight(dayCtl.imageView.bounds) / 2;
                    dayCtl.imageView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                    dayCtl.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dayCtl.bounds.size.width, dayCtl.bounds.size.height)];
                    dayCtl.label.font = [UIFont systemFontOfSize:15];
                    dayCtl.label.textAlignment = NSTextAlignmentCenter;
                    dayCtl.label.textColor = [UIColor whiteColor];
                    dayCtl.label.text = titleText;
                    [dayCtl addSubview:dayCtl.imageView];
                    [dayCtl addSubview:dayCtl.label];
                    [dayCtl addTarget:self action:@selector(daysButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:dayCtl];
                } else {
                
                    ImageControl *dayCtl = [[ImageControl alloc] initWithFrame:dayFrame];
                    dayCtl.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((dayCtl.bounds.size.width-45/2)/2, (dayCtl.bounds.size.height-45/2)/2, 45/2, 45/2)];
                    dayCtl.imageView.layer.cornerRadius = CGRectGetHeight(dayCtl.imageView.bounds) / 2;
                    dayCtl.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dayCtl.bounds.size.width, dayCtl.bounds.size.height)];
                    dayCtl.label.font = [UIFont systemFontOfSize:15];
                    dayCtl.label.textAlignment = NSTextAlignmentCenter;
                    dayCtl.label.textColor = [ColorHandler colorWithHexString:@"#413445"];
                    dayCtl.label.text = titleText;
                    [dayCtl addSubview:dayCtl.imageView];
                    [dayCtl addSubview:dayCtl.label];
                    [dayCtl addTarget:self action:@selector(daysButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:dayCtl];
                }
                
            }
            //next day
            day.day = day.day + 1;
            nextDayViewOrigin.x += daysButtonWidth;
        }
        //next week
        nextDayViewOrigin.x = 0;
        nextDayViewOrigin.y += daysButtonHeight;
        startColumn = 0;
        
    } while (day.day <= numberOfDaysInMonth);
    
}

- (void)daysButtonClicked:(ImageControl *)button {
    NSString *YYYY = [[NSString alloc] initWithFormat:@"%2d",[_month year]];
    NSString *MM;
    if ([_month month]<10) {
        MM = [[NSString alloc] initWithFormat:@"0%d",[_month month]];
    } else {
        MM = [[NSString alloc] initWithFormat:@"%d",[_month month]];
    }
    NSString *DD;
    if (button.label.text.length == 1) {
        DD = [[NSString alloc] initWithFormat:@"0%@",button.label.text];
    } else {
        DD = button.label.text;
    }
    _dateSelected = [[NSString alloc] initWithFormat:@"%@%@%@",YYYY,MM,DD];
    [self createDaysButton];
    [self.delegate refineDateView];
    
}


@end
