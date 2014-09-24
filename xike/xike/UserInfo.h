//
//  UserInfo.h
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (strong ,nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSData *photo;
@property (strong, nonatomic) NSData *backgroundPic;
@property (strong, nonatomic) NSString *QQ;
@property (strong, nonatomic) NSString *weibo;
@property (strong, nonatomic) NSString *weixin;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *ID;

@end
