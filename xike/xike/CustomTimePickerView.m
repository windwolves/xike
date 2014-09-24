//
//  CustomTimePickerView.m
//  xike
//
//  Created by Leading Chen on 14-9-4.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CustomTimePickerView.h"
#import "CycleScrollView.h"
#import "ColorHandler.h"

@implementation CustomTimePickerView {
    UIView                   *timeBroadcastView;//定时播放显示视图
    CycleScrollView          *hourScrollView;//时滚动视图
    CycleScrollView          *minuteScrollView;//分滚动视图
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTimeBroadcastView];
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

- (void)setTimeBroadcastView {
    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self setHourScrollView];
    [self setMinuteScrollView];
    [self addSubview:timeBroadcastView];
}


//设置时的滚动视图
- (void)setHourScrollView
{
    hourScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(159.5, 0, 39.0, 190.0)];
    NSInteger hourint = [self setNowTimeShow:3];
    [hourScrollView setCurrentSelectPage:(hourint-2)];
    hourScrollView.delegate = self;
    hourScrollView.datasource = self;
    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:hourScrollView];
}
//设置分的滚动视图
- (void)setMinuteScrollView
{
    minuteScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(198.5, 0, 37.0, 190.0)];
    NSInteger minuteint = [self setNowTimeShow:4];
    [minuteScrollView setCurrentSelectPage:(minuteint-2)];
    minuteScrollView.delegate = self;
    minuteScrollView.datasource = self;
    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:minuteScrollView];
}

- (void)setAfterScrollShowView:(CycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
}
/*
- (void)setAfterScrollShowView:(CycleScrollView *)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    NSArray *a = [scrollview subviews];
    UILabel *oneLabel = (UILabel*)[a objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    UILabel *twoLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    
    UILabel *currentLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    
    UILabel *threeLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    UILabel *fourLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
}
*/

#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(CycleScrollView*)scrollView
{

    if (scrollView == hourScrollView)
    {
        return 24;
    }
    else if (scrollView == minuteScrollView)
    {
        return 60;
    }
    return 60;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(CycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == hourScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%d",index];
        }
        else
            l.text = [NSString stringWithFormat:@"%d",index];
    }
    else if (scrollView == minuteScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%d",index];
        }
        else
            l.text = [NSString stringWithFormat:@"%d",index];
    }
    else
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%d",index];
        }
        else
            l.text = [NSString stringWithFormat:@"%d",index];
    
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}
//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 4:
        {
            NSRange range = NSMakeRange(10, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 5:
        {
            NSRange range = NSMakeRange(12, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        default:
            break;
    }
    return 0;
}
//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    NSInteger yearInt = [selectDate substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].integerValue;
    int c = 20;//世纪
    int y = yearInt -1;//年
    int d = dayInt;
    int m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0:
            weekDay = @"周日";
            break;
        case 1:
            weekDay = @"周一";
            break;
        case 2:
            weekDay = @"周二";
            break;
        case 3:
            weekDay = @"周三";
            break;
        case 4:
            weekDay = @"周四";
            break;
        case 5:
            weekDay = @"周五";
            break;
        case 6:
            weekDay = @"周六";
            break;
        default:
            break;
    }
    return weekDay;
}



@end
