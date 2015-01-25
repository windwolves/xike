//
//  EventInfo.m
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "EventInfo.h"
#import "XikeDatabase.h"
#import "UserInfo.h"

@implementation EventInfo

- (id)init {
    self = [super init];
    
    self.themeType = @"";
    self.theme = @"";
    self.content = @"";
    self.location = @"";
    self.date = @"";
    self.time = @"";
    self.host = [[PeopleInfo alloc] initWithID:_user.userID Name:_user.name Phone:_user.phone Photo:nil];
    self.guestList = [NSMutableArray new];
    self.templateID = @"";
    self.send_status = 1; //0 not send; 1 send
    
    return self;
}

- (id)initWithID:(NSInteger)eventID ThemeType:(NSString *)themeType Theme:(NSString *)theme Content:(NSString *)content Location:(NSString *)location Date:(NSString *)date Time:(NSString *)time Host:(PeopleInfo *)host GuestList:(NSArray *)guestList TemplateID:(NSString *)templateID {
    self = [super init];
    self.eventID = eventID;
    self.themeType = themeType;
    self.theme = theme;
    self.content = content;
    self.location = location;
    self.date = date;
    self.time = time;
    self.host = host;
    self.guestList = guestList;
    self.templateID = templateID;
    
    return self;
}

@end
