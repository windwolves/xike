//
//  ImageControl.h
//  xike
//
//  Created by Leading Chen on 14-9-2.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateInfo.h"

@interface ImageControl : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *controlID;
@property (nonatomic, strong) TemplateInfo *template;

@end
