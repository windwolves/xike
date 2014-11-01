//
//  TemplateDisplayViewController.h
//  xike
//
//  Created by Leading Chen on 14/10/29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"
#import "XikeDatabase.h"
#import "UserInfo.h"

@interface TemplateDisplayViewController : UIViewController <ImageScrollViewDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;
@end
