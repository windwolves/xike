//
//  ChangePasswordViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;

@end
