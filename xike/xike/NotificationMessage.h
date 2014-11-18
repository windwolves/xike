//
//  NotificationMessage.h
//  xike
//
//  Created by Leading Chen on 14/11/14.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationMessage : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *type;
//1 = invitation accepted
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSData *pic;
@property (nonatomic, strong) NSString *eventUUID;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, strong) NSString *user;

@end
