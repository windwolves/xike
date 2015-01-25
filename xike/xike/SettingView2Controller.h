//
//  SettingView2Controller.h
//  xike
//
//  Created by Leading Chen on 14/12/5.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "UserInfo.h"
#import "ImageCropperViewController.h"

@protocol SettingView2ControllerDelegate <NSObject>

- (void)didFinishAccountSettingwith:(UserInfo *)user;

@end

@interface SettingView2Controller : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,ImageCropperDelegate,NSURLSessionDataDelegate>
@property (nonatomic, strong) id <SettingView2ControllerDelegate> delegate;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImage *pic;

@end
