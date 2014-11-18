//
//  NotificationTableViewCell.m
//  xike
//
//  Created by Leading Chen on 14/11/15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 4, 48, 74)];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 28, self.bounds.size.width - 9 , 15)];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:_picView];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)setNotification:(NotificationMessage *)notification {
    _notification = notification;
    _picView.image = [UIImage imageWithData:_notification.pic];
    _messageLabel.text = _notification.content;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
