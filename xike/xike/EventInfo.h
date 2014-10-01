//
//  EventInfo.h
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeopleInfo.h"
#import "UserInfo.h"
#import "TemplateInfo.h"

@interface EventInfo : NSObject
@property (assign, nonatomic) NSInteger eventID;
@property (strong, nonatomic) NSString *themeType;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) PeopleInfo *host;
@property (strong, nonatomic) NSArray *guestList;
@property (strong, nonatomic) NSString *templateID;
@property (assign, nonatomic) NSInteger send_status;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) TemplateInfo *template;

- (id)initWithID:(NSInteger)eventID ThemeType:(NSString *)themeType Theme:(NSString *)theme Content:(NSString *)content Location:(NSString *)location Date:(NSString *)date Time:(NSString *)time Host:(PeopleInfo *)host GuestList:(NSArray *)guestList TemplateID:(NSString *)templateID;
@end
