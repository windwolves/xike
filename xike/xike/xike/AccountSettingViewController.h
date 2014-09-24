//
//  AccountSettingViewController.h
//  xike
//
//  Created by Leading Chen on 14-8-29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "XikeDatabase.h"

@class AccountSettingViewController;
@protocol AccountSettingViewControllerDelegate <NSObject>

- (void)didFinishAccountSettingwith:(UIImage *)backgroundImage :(UIImage *)picture;

@end
@interface AccountSettingViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) id <AccountSettingViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *pictureView;
@property (strong, nonatomic) XikeDatabase *database;
@property (strong, nonatomic) UserInfo *user;

@end
