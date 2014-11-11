//
//  UserLogonViewController.h
//  xike
//
//  Created by Leading Chen on 14-8-23.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "ForgetPasswordViewController.h"
#import "ShareEngine.h"

@interface UserLogonViewController : UIViewController <UITextFieldDelegate, NSURLSessionDataDelegate,ShareEngineDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (strong, nonatomic) NSString *deviceToken;

@end
