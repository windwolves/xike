//
//  CRJContactTableViewCell.m
//  Qing
//
//  Created by Leading Chen on 14-6-21.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CRJContactTableViewCell.h"

@implementation CRJContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.accessoryType = UITableViewCellAccessoryDetailButton;
        
        _fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 10, 200, 15)];
        _fullNameLabel.textColor = [UIColor whiteColor];
        _fullNameLabel.tag = 101;
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 25, 132, 20)];
        _numberLabel.textColor = [UIColor whiteColor];
        [_numberLabel setFont: [UIFont systemFontOfSize:13]];
        _numberLabel.tag = 102;
        _pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 5, 40, 40)];
        _pictureImageView.tag = 103;
        _checkboxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 13, 25, 25)];
        _checkboxImageView.tag = 104;
        
        [self addSubview:_fullNameLabel];
        [self addSubview:_numberLabel];
        [self addSubview:_pictureImageView];
        [self addSubview:_checkboxImageView];
    }
    return self;
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
