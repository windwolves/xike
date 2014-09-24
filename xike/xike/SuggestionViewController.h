//
//  SuggestionViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface SuggestionViewController : UIViewController <UITextViewDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) UserInfo *user;

@end
