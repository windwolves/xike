//
//  GuidePage.m
//  xike
//
//  Created by Leading Chen on 14-10-15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "GuidePage.h"

@implementation GuidePage

+ (GuidePage *)page {
    GuidePage *newPage = [[GuidePage alloc] init];
    newPage.imgPositionY    = 50.0f;
    newPage.titlePositionY  = 160.0f;
    newPage.descPositionY   = 140.0f;
    newPage.title = @"";
    newPage.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    newPage.titleColor = [UIColor whiteColor];
    newPage.desc = @"";
    newPage.descFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    newPage.descColor = [UIColor whiteColor];
    
    return newPage;
}

+ (GuidePage *)pageWithCustomView:(UIView *)customV {
    GuidePage *newPage = [[GuidePage alloc] init];
    newPage.customView = customV;
    
    return newPage;
}

@end
