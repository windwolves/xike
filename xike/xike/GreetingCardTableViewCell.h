//
//  GreetingCardTableViewCell.h
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreetingInfo.h"
#import "TemplateInfo.h"

@class GreetingCardTableViewCell;
@protocol GreetingCardTableViewCellDelegate <NSObject>

- (TemplateInfo *)getTemplateByID:(NSString *)templateID;

@end

@interface GreetingCardTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *tempalteImageView;
@property (nonatomic, strong) UILabel *yearMonthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekdayLabel;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) GreetingInfo *greeting;
@property (nonatomic, strong) id <GreetingCardTableViewCellDelegate> delegate;

- (void)setGreeting:(GreetingInfo *)greeting;
@end
