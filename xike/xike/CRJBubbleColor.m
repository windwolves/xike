//
//  CRJBubbleColor.m
//  Qing
//
//  Created by Leading Chen on 14-6-21.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CRJBubbleColor.h"

@implementation CRJBubbleColor
- (id)initWithGradientTop:(UIColor *)gradientTop gradientBottom:(UIColor *)gradientBottom border:(UIColor *)border {
    if (self = [super init]) {
        self.gradientTop = gradientTop;
        self.gradientBottom = gradientBottom;
        self.border = border;
    }
    return self;
}
@end
