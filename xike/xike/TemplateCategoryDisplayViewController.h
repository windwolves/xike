//
//  TemplateCategoryDisplayViewController.h
//  xike
//
//  Created by Leading Chen on 14/10/30.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"

@interface TemplateCategoryDisplayViewController : UIViewController
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, assign) NSInteger category;

@end
