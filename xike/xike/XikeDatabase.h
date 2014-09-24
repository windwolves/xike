//
//  XikeDatabase.h
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "UserInfo.h"
#import "EventInfo.h"
#import "PeopleInfo.h"

@interface XikeDatabase : NSObject
- (void)openDatabase;
- (void)closeDatabase;
- (BOOL)createAllTables;
- (BOOL)setUser:(UserInfo *)user;
- (BOOL)updateUser:(UserInfo *)user;
- (NSString *)getUserPassword:(UserInfo *)user;
- (BOOL)updateUserPassword:(UserInfo *)user;
- (UserInfo *)getUserInfo;
- (BOOL)setLastUesdUser:(UserInfo *)user;
- (BOOL)whetherUserExisted:(UserInfo *)user;

- (NSMutableArray *)getAllEvents:(UserInfo *)user;
- (NSInteger)createEvent:(EventInfo *)event :(UserInfo *)user;
- (BOOL)updateEvent:(EventInfo *)event;
- (BOOL)deleteEvent:(EventInfo *)event;
- (NSString *)getCurrentEventID;

//- (BOOL)insertTestUser; //test use;
@end
