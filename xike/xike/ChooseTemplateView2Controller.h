//
//  ChooseTemplateView2Controller.h
//  xike
//
//  Created by Leading Chen on 14/12/10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "XikeDatabase.h"

@interface ChooseTemplateView2Controller : UIViewController
@property (nonatomic, strong) NSString *createItem;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) XikeDatabase *database;

@end
