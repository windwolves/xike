//
//  GreetingCardTableViewCell.m
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "GreetingCardTableViewCell.h"
#import "ColorHandler.h"

@implementation GreetingCardTableViewCell


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
        
        _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, 23, 160, 15)];
        _themeLabel.font = [UIFont systemFontOfSize:15];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, 35, 160, 24)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        
        _tempalteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 5, 48, 74)];
        
        [self addSubview:_yearMonthLabel];
        [self addSubview:_dayLabel];
        [self addSubview:_weekdayLabel];
        [self addSubview:_themeLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_tempalteImageView];
        
    }
    return self;
}

- (void)setGreeting:(GreetingInfo *)greeting {
    _greeting = greeting;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *YYYY;
    NSString *MM;
    NSString *DD;
    if (_greeting.create_date.length == 8) {
        NSDate *Date = [formatter dateFromString:_greeting.create_date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit fromDate:Date];
        
        YYYY = [_greeting.create_date substringWithRange:NSMakeRange(0, 4)];
        MM = [_greeting.create_date substringWithRange:NSMakeRange(4, 2)];
        DD = [_greeting.create_date substringWithRange:NSMakeRange(6, 2)];
        _yearMonthLabel.text = [[NSString alloc] initWithFormat:@"%@年%@月",YYYY,MM];
        _dayLabel.text = DD;
        [formatter setDateFormat:@"EEEE"];
        _weekdayLabel.text = [self getWeekdayString:components.weekday];
    } else {
        _yearMonthLabel.text = @"";
        _dayLabel.text = @"";
        _weekdayLabel.text = @"待定";
    }
    if ([_greeting.theme isEqualToString:@"Christmas"]) {
        _themeLabel.text = @"圣诞贺卡";
    } else if ([_greeting.theme isEqualToString:@"NewYearDay"]) {
        _themeLabel.text = @"元旦贺卡";
    } else if ([_greeting.theme isEqualToString:@"Spring"]) {
        _themeLabel.text = @"春节贺卡";
    } else if ([_greeting.theme isEqualToString:@"Valentine"]) {
        _themeLabel.text = @"情人节贺卡";
    }
    _contentLabel.text = _greeting.content;
    
    _tempalteImageView.image = [UIImage imageWithData:_greeting.template.thumbnail];
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
