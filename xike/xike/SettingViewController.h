//
//  SettingViewController.h
//  xike
//
//  Created by Leading Chen on 14-8-27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"
#import "AccountSettingViewController.h"

@protocol SettingViewControllerDelegate <NSObject>
typedef enum _SideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1
}SideBarShowDirection;
- (void)pushViewController:(UIViewController *)viewController;
- (void)changeUserInfo:(UserInfo *)user;
@end

@interface SettingViewController : UIViewController <AccountSettingViewControllerDelegate>
@property (nonatomic, strong) id <SettingViewControllerDelegate> delegate;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;

@end
