//
//  NotificationTableViewCell.h
//  xike
//
//  Created by Leading Chen on 14/11/15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationMessage.h"

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NotificationMessage *notification;

- (void)setNotification:(NotificationMessage *)notification;
@end
