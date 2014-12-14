//
//  MyBoxViewController.h
//  xike
//
//  Created by Leading Chen on 14/12/7.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "XikeDatabase.h"
#import "ImageCropperViewController.h"
#import "SettingView2Controller.h"

@interface MyBoxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,ImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,NSURLSessionDataDelegate,SettingView2ControllerDelegate>
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UITableView *eventsTable;
@property (nonatomic, strong) UITableView *greetingsTables;

@end
