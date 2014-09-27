//
//  TemplateTableViewCell.m
//  xike
//
//  Created by Leading Chen on 14-9-27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "TemplateTableViewCell.h"

@implementation TemplateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 51, 81)];
        imageView.image = [UIImage imageWithData:_template.thumbnail];
        [self addSubview:imageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
