//
//  FastInpuGreetingWordsViewController.h
//  xike
//
//  Created by Leading Chen on 14/12/11.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreetingInfo.h"
#import "UserInfo.h"
#import "XikeDatabase.h"

@protocol FastInpuGreetingWordsViewControllerDelegate <NSObject>

- (void)done:(NSString *)content;

@end

@interface FastInpuGreetingWordsViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) GreetingInfo *greeting;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) id <FastInpuGreetingWordsViewControllerDelegate> delegate;

@end
