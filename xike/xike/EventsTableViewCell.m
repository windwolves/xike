//
//  EventsTableViewCell.m
//  xike
//
//  Created by Leading Chen on 14-9-17.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "EventsTableViewCell.h"
#import "ColorHandler.h"

@implementation EventsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _yearMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, 110, 12)];
        _yearMonthLabel.font = [UIFont systemFontOfSize:12];
        _yearMonthLabel.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
        
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 110, 40)];
        _dayLabel.font = [UIFont systemFontOfSize:55];
        _dayLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
        
        _weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 67, 110, 12)];
        _weekdayLabel.font = [UIFont systemFontOfSize:12];
        _weekdayLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];

        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, 23, 200, 15)];
        
        UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(91, 67, 7, 10)];
        locationImageView.image = [UIImage imageNamed:@"location_icon"];
        _locationLaebl = [[UILabel alloc] initWithFrame:CGRectMake(109, 67, 100, 12)];
        _locationLaebl.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
        _locationLaebl.font = [UIFont systemFontOfSize:12];
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 67, 10, 10)];
        timeImageView.image = [UIImage imageNamed:@"time_icon"];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 67, 60, 12)];
        _timeLabel.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
        _timeLabel.font = [UIFont systemFontOfSize:12];

        _tempalteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(269, 5, 48, 74)];
        
        [self addSubview:_yearMonthLabel];
        [self addSubview:_dayLabel];
        [self addSubview:_weekdayLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_tempalteImageView];
        [self addSubview:locationImageView];
        [self addSubview:_locationLaebl];
        [self addSubview:timeImageView];
        [self addSubview:_timeLabel];

    }
    return self;
}

- (void)setEvent:(EventInfo *)event {
    _event = event;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *YYYY;
    NSString *MM;
    NSString *DD;
    if (_event.date.length == 8) {
        NSDate *eventDate = [formatter dateFromString:_event.date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit fromDate:eventDate];
        
        YYYY = [_event.date substringWithRange:NSMakeRange(0, 4)];
        MM = [_event.date substringWithRange:NSMakeRange(4, 2)];
        DD = [_event.date substringWithRange:NSMakeRange(6, 2)];
        _yearMonthLabel.text = [[NSString alloc] initWithFormat:@"%@年%@月",YYYY,MM];
        _dayLabel.text = DD;
        [formatter setDateFormat:@"EEEE"];
        _weekdayLabel.text = [self getWeekdayString:components.weekday];
    } else {
        _yearMonthLabel.text = @"";
        _dayLabel.text = @"";
        _weekdayLabel.text = @"";
    }
    
    if (_event.send_status == 0) {
        _contentLabel.text = [[NSString alloc] initWithFormat:@"(草稿) %@",_event.content];
    } else {
        _contentLabel.text = _event.content;
    }
    if (_contentLabel.text.length > 10) {
        _contentLabel.text = [[NSString alloc] initWithFormat:@"%@…",[_contentLabel.text substringToIndex:10]];
    }
    
    if (_event.location.length > 6) {
        _locationLaebl.text = [[NSString alloc] initWithFormat:@"%@…",[_event.location substringToIndex:6]];
    } else {
        _locationLaebl.text = _event.location;
    }
    
    if (_event.time.length > 5) {
        _timeLabel.text = [_event.time substringToIndex:5];
    } else {
        _timeLabel.text = @"待定";
    }
    _tempalteImageView.image = [UIImage imageWithData:_event.template.thumbnail];
}

- (UIImage *)getTemplateImage {
    TemplateInfo *template = [self.delegate getTemplateByID:_event.templateID];
    UIImage *thumbnail = [UIImage imageWithData:template.thumbnail];
    return thumbnail;
}

- (NSString *)getWeekdayString:(NSInteger)number {
    if (number == 1) {
        return @"星期日";
    } else if (number == 2) {
        return @"星期一";
    } else if (number == 3) {
        return @"星期二";
    } else if (number == 4) {
        return @"星期三";
    } else if (number == 5) {
        return @"星期四";
    } else if (number == 6) {
        return @"星期五";
    } else if (number == 7) {
        return @"星期六";
    } else {
        return @"";
    }
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
