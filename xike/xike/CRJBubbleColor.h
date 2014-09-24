//
//  CRJBubbleColor.h
//  Qing
//
//  Created by Leading Chen on 14-6-21.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRJBubbleColor : NSObject
@property (nonatomic, strong) UIColor *gradientTop;
@property (nonatomic, strong) UIColor *gradientBottom;
@property (nonatomic, strong) UIColor *border;

- (id)initWithGradientTop:(UIColor *)gradientTop gradientBottom:(UIColor *)gradientBottom border:(UIColor *)border;

@end
