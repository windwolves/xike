//
//  XikeDatabase.m
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "XikeDatabase.h"

@implementation XikeDatabase
static sqlite3 *_database;

- (id)init {
    self = [super init];
    return self;
}

- (void)openDatabase {
    NSArray *sqLiteDbPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sqLiteDb = [[sqLiteDbPaths objectAtIndex:0] stringByAppendingPathComponent:@"Xike.sqlite3"];
    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK) {
        NSLog(@"open is ok");
    }
    
}

- (void)closeDatabase {
    sqlite3_close(_database);
    NSLog(@"close is ok");
}

- (BOOL)createAllTables {
    [self openDatabase];
    char *errMsg;
    const char *createUserInfoSQL = "create table if not exists userinfo (user_id text, name text default null,phone text default null,photo blob defalut null,background_pic blob default null,QQ text default null,weibo text default null,weixin text default null,password text,gender text default null,deviceToken text,last_used integer,ID text)";
    const char *createEventInfoSQL = "create table if not exists eventinfo (event_id integer primary key, theme_type text, theme text, content text, location text, date text, time text, host_id text, host_name text, host_pic blob, host_phone text,template_id text,send_status integer, create_datetime timestamp default current_timestamp,user_id text,uuid text default null)";
    const char *createGuestInfoSQL = "create table if not exists guestinfo (event_uuid integer,guest_id text,guest_name text, guest_phone text,guest_pic blob defalut null)";
    const char *createFriendInfoSQL = "create table if not exists friendinfo (user_id text, name text,phone text,photo blob defalut null)";
    const char *createTemplateInfoSQL = "create table if not exists templateinfo (uuid text, name text, desc text,thumbnail blob defalut null,category text,recommendation int)";
    
    if (sqlite3_exec(_database, createUserInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"userinfo created");
        
    } else {
        NSLog(@"userinfo creation failed!");
        [self ErrorReport:createUserInfoSQL];
        [self closeDatabase];
        return NO;
    }
    if (sqlite3_exec(_database, createEventInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"eventinfo created!");
    } else {
        NSLog(@"eventinfo creation failed!");
        [self ErrorReport:createEventInfoSQL];
        [self closeDatabase];
        return NO;
    }
    if (sqlite3_exec(_database, createGuestInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"guestinfo created!");
    } else {
        NSLog(@"guestinfo creation failed!");
        [self ErrorReport:createGuestInfoSQL];
        [self closeDatabase];
        return NO;
    }
    if (sqlite3_exec(_database, createFriendInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"friendinfo created!");
    } else {
        NSLog(@"friendinfo creation failed!");
        [self ErrorReport:createFriendInfoSQL];
        [self closeDatabase];
        return NO;
    }
    if (sqlite3_exec(_database, createTemplateInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"templateInfo created!");
    } else {
        NSLog(@"templateInfo creation failed!");
        [self ErrorReport:createTemplateInfoSQL];
        [self closeDatabase];
        return NO;
    }
    [self closeDatabase];
    return YES;
}

- (BOOL)setUser:(UserInfo *)user {
    [self openDatabase];
    const char *insertUserInfoSQL = "Insert into userinfo (user_id,password,deviceToken,ID) values (?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertUserInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [user.password UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [user.deviceToken UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [user.ID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"insert user failed!");
            [self ErrorReport:insertUserInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (BOOL)updateUser:(UserInfo *)user {
    [self openDatabase];
    const char *updateUserInfoSQL = "update userinfo set name=?,phone=?,photo=?,background_pic=?,QQ=?,weibo=?,weixin=?,gender=? where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updateUserInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [user.phone UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 3, [user.photo bytes], (int)[user.photo length], NULL);
        sqlite3_bind_blob(stmt, 4, [user.backgroundPic bytes], (int)[user.backgroundPic length], NULL);
        sqlite3_bind_text(stmt, 5, [user.QQ UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [user.weibo UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [user.weixin UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [user.gender UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [user.userID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"Update User failed!");
            [self ErrorReport:updateUserInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}


- (NSString *)getUserPassword:(UserInfo *)user {
    NSString *password;
    [self openDatabase];
    const char *getPasswordSQL = "select password from userinfo where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getPasswordSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, nil);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            password = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        }
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return password;
}

- (BOOL)updateUserPassword:(UserInfo *)user {
    [self openDatabase];
    const char *updatePasswordSQL = "update userinfo set password=? where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updatePasswordSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.password UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [user.userID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"Update Password failed!");
            [self ErrorReport:updatePasswordSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
    
    return YES;
}

- (BOOL)whetherUserExisted:(UserInfo *)user {
    [self openDatabase];
    const char *checkSQL = "select count(*) from userinfo where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, checkSQL, -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_int(stmt, 0) > 0) {
                return YES;
            }
        }
    }
    return NO;
}


- (UserInfo *)getUserInfo {
    UserInfo *user = [UserInfo new];
    [self openDatabase];
    const char *getUserInfoSQL = "select user_id,name,phone,photo,background_pic,QQ,weibo,weixin,gender,ID from userinfo where last_used = 1";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getUserInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_text(stmt, 0)) {
                user.userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
            if (sqlite3_column_text(stmt, 1)) {
                user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            } else {
                user.name = user.userID;
            }
            if (sqlite3_column_text(stmt, 2)) {
                user.phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            }
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                user.photo = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)];
            }
            if (sqlite3_column_bytes(stmt, 4) != 0) {
                user.backgroundPic = [NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:sqlite3_column_bytes(stmt, 4)];
            }
            //NSLog(@"%d",sqlite3_column_bytes(stmt, 3));
            if (sqlite3_column_text(stmt, 5)) {
                user.QQ = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
            }
            if (sqlite3_column_text(stmt, 6)) {
                user.weibo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
            }
            if (sqlite3_column_text(stmt, 7)) {
                user.weixin = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
            }
            if (sqlite3_column_text(stmt, 8)) {
                user.gender = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
            }
            if (sqlite3_column_text(stmt, 9)) {
                user.ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
            }
        }
    }
    
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return user;
}

- (BOOL)setLastUesdUser:(UserInfo *)user {
    [self openDatabase];
    const char *updatePasswordSQL = "update userinfo set last_used = 1 where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updatePasswordSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"set last user failed!");
            [self ErrorReport:updatePasswordSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
    
    return YES;
    
}

- (NSMutableArray *)getAllEvents:(UserInfo *)user {
    [self openDatabase];
    NSMutableArray *Events = [NSMutableArray new];
    const char *getEventInfoSQL = "select uuid,theme_type,theme,content,location,date,time,host_id,host_name,host_pic,host_phone,template_id,send_status from eventinfo where user_id = ? order by date desc,time desc";
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_database, getEventInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            EventInfo *event = [EventInfo new];
            event.uuid = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            event.themeType = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            event.theme = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            event.content = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
            event.location = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
            event.date = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
            event.time = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
            NSString *host_id;
            if (sqlite3_column_text(stmt, 7)) {
                host_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
            } else {
                host_id = @"";
            }
            NSString *host_name;
            if (sqlite3_column_text(stmt, 8)) {
                host_name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
            } else {
                host_name = @"";
            }
            NSData *host_pic;
            if (sqlite3_column_bytes(stmt, 9) != 0) {
                host_pic = [NSData dataWithBytes:sqlite3_column_blob(stmt, 9) length:sqlite3_column_bytes(stmt, 9)];
            } else {
                host_pic = nil;
            }
            NSString *host_phone;
            if (sqlite3_column_text(stmt, 10)) {
                host_phone = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 10)];
            } else {
                host_phone = @"";
            }
            if (sqlite3_column_text(stmt, 11)) {
                event.templateID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 11)];
            } else {
                event.templateID = @"ff8845e1-ec9f-4f3e-aeb9-e6b6179817e5";
            }
            event.send_status = (NSInteger)sqlite3_column_int(stmt, 12);
            
            event.host = [[PeopleInfo alloc] initWithID:host_id Name:host_name Phone:host_phone Photo:host_pic];
            //event.guestList = [self getGuestListwith:event.uuid];
            event.template = [self getTemplate:event.templateID];
            [Events addObject:event];
        }
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return Events;
}

- (NSMutableArray *)getGuestListwith:(NSString *)uuid {
    NSMutableArray *guestList = [NSMutableArray new];
    const char *getGuestInfoSQL = "select guest_id,guest_name,guest_phone,guest_pic from guestinfo where event_uuid = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getGuestInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [uuid UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *guest_id, *guest_name, *guest_phone;
            NSData *guest_pic;
            
            guest_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            guest_name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            guest_phone = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            guest_pic = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)];
            PeopleInfo *guest = [[PeopleInfo alloc] initWithID:guest_id Name:guest_name Phone:guest_phone Photo:guest_pic];
            [guestList addObject:guest];
        }
    } else {
        NSLog(@"Get guestList Failed!");
        [self ErrorReport:getGuestInfoSQL];
        [self closeDatabase];
    }
    sqlite3_finalize(stmt);
    return guestList;
}

- (NSInteger)getEventID {
    [self openDatabase];
    const char *getEventIDSQL = "select max(event_id) from eventinfo";
    sqlite3_stmt *stmt;
    NSInteger eventID;
    if (sqlite3_prepare_v2(_database, getEventIDSQL, -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            eventID = sqlite3_column_int(stmt, 0);
        }
    } else {
        NSLog(@"Get eventID Failed!");
        [self ErrorReport:getEventIDSQL];
        [self closeDatabase];
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return eventID;;
}

- (NSInteger)createEvent:(EventInfo *)event :(UserInfo *)user {
    [self openDatabase];
    const char *insertNewEventSQL = "insert into eventinfo (theme_type,theme,content,location,date,time,host_id,host_name,host_pic,host_phone,template_id,send_status,user_id,uuid) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertNewEventSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [event.themeType UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [event.theme UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [event.content UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [event.location UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [event.date UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [event.time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [event.host.user_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [event.host.name UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 9, [event.host.photo bytes], -1, NULL);
        sqlite3_bind_text(stmt, 10,[event.host.phone UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11,[event.templateID UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 12, event.send_status);
        sqlite3_bind_text(stmt, 13, [user.userID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 14, [event.uuid UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            
            return [self getEventID];
        } else {
            NSLog(@"insert event failed!");
            [self ErrorReport:insertNewEventSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return 0;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return 0;
    }
}

- (BOOL)createEventGuestList:(EventInfo *)event {
    [self openDatabase];
    const char *insertEventGuestListSQL = "Insert into guestinfo (event_uuid,guest_id,guest_name,guest_phone,guest_pic) values (?,?,?,?,?)";
    sqlite3_stmt *stmt;
    for (int i=0; i<[event.guestList count]; i++) {
        PeopleInfo *guest = [event.guestList objectAtIndex:i];
        if (sqlite3_prepare_v2(_database, insertEventGuestListSQL, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [event.uuid UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [guest.user_id UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [guest.name UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 4, [guest.phone UTF8String], -1, NULL);
            sqlite3_bind_blob(stmt, 5, [guest.photo bytes], (int)[guest.photo length], NULL);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                continue;
            } else {
                NSLog(@"insert guestInfo failed!");
                [self ErrorReport:insertEventGuestListSQL];
                sqlite3_finalize(stmt);
                [self closeDatabase];
                return NO;
            }
        } else {
            NSLog(@"prepareStatement failed!");
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    }
    [self closeDatabase];
    return YES;
}

- (BOOL)updateEvent:(EventInfo *)event {
    [self openDatabase];
    const char *updateEventSQL = "update eventinfo set theme_type=?,theme=?,content=?,location=?,date=?,time=?,host_id=?,host_name=?,host_pic=?,host_phone=?,template_id=?,send_status=? where uuid = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updateEventSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [event.themeType UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [event.theme UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [event.content UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [event.location UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [event.date UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [event.time UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [event.host.user_id UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [event.host.name UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 9, [event.host.photo bytes], -1, NULL);
        sqlite3_bind_text(stmt, 10,[event.host.phone UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 11,[event.templateID UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 12,event.send_status);
        sqlite3_bind_text(stmt, 13, [event.uuid UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            NSLog(@"Updated!");
            [self closeDatabase];
            return [self createEventGuestList:event];
        } else {
            sqlite3_finalize(stmt);
            NSLog(@"update failed!");
            [self ErrorReport:updateEventSQL];
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
    
}

- (BOOL)deleteEvent:(EventInfo *)event {
    [self openDatabase];
    const char *deleteEventSQL = "delete from eventinfo where uuid = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, deleteEventSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [event.uuid UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            NSLog(@"deleted!");
            [self closeDatabase];
            return [self deleteEventGuestList:event];
            
        } else {
            sqlite3_finalize(stmt);
            [self ErrorReport:deleteEventSQL];
            NSLog(@"delete failed!");
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatment failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (BOOL)deleteEventGuestList:(EventInfo *)event {
    [self openDatabase];
    const char *deleteEventGuestSQL = "delete from guestinfo where uuid = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, deleteEventGuestSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [event.uuid UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            NSLog(@"deleted!");
            [self closeDatabase];
            return YES;
        } else {
            sqlite3_finalize(stmt);
            NSLog(@"delete failed!");
            [self ErrorReport:deleteEventGuestSQL];
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatment failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (NSString *)getCurrentEventID {
    [self openDatabase];
    const char *getCurrentEventIDSQL = "select top 1 event_id from eventinfo order by date desc, time desc";
    sqlite3_stmt *stmt;
    NSString *eventID = [NSString new];
    if (sqlite3_prepare_v2(_database, getCurrentEventIDSQL, -1, &stmt, nil) == SQLITE_OK) {
        eventID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
    } else {
        NSLog(@"Get EventID failed!");
        [self ErrorReport:getCurrentEventIDSQL];
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return eventID;
}


- (BOOL)insertTemplate:(TemplateInfo *)template {
    [self openDatabase];
    const char *insertTemplateInfoSQL = "Insert into templateinfo (uuid,name,desc,thumbnail,category,recommendation) values (?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertTemplateInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [template.ID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [template.name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [template.desc UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 4, [template.thumbnail bytes], (int)[template.thumbnail length], NULL);
        sqlite3_bind_text(stmt, 5, [template.category UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 6, template.recommendation);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"insert template failed!");
            [self ErrorReport:insertTemplateInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (TemplateInfo *)getTemplate:(NSString *)templateID {
    [self openDatabase];
    TemplateInfo *template = [TemplateInfo new];
    const char *getEventInfoSQL = "select uuid,name,desc,thumbnail,category,recommendation from templateinfo where uuid = ?";
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_database, getEventInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [templateID UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_text(stmt, 0)) {
                template.ID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            } else {
                template.ID = @"";
            }
            if (sqlite3_column_text(stmt, 1)) {
                template.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            } else {
                template.name = @"";
            }
            if (sqlite3_column_text(stmt, 2)) {
                template.desc = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            } else {
                template.desc = @"";
            }
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                template.thumbnail = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)];
            } else {
                template.thumbnail = nil;
            }
            if (sqlite3_column_text(stmt, 4)) {
                template.category = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
            } else {
                template.category = @"";
            }
            if (sqlite3_column_int(stmt, 5)) {
                template.recommendation = sqlite3_column_int(stmt, 5);
            } else {
                template.recommendation = 0;
            }
        }
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return template;
    
}

- (NSMutableArray *)getAllTemplates {
    [self openDatabase];
    NSMutableArray *templates = [NSMutableArray new];
    const char *getEventInfoSQL = "select uuid,name,desc,thumbnail,category,recommendation from templateinfo";
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_database, getEventInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            TemplateInfo *template = [TemplateInfo new];
            if (sqlite3_column_text(stmt, 0)) {
                template.ID = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            } else {
                template.ID = @"";
            }
            if (sqlite3_column_text(stmt, 1)) {
                template.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            } else {
                template.name = @"";
            }
            if (sqlite3_column_text(stmt, 2)) {
                template.desc = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            } else {
                template.desc = @"";
            }
            //NSInteger a = sqlite3_column_bytes(stmt, 3);
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                template.thumbnail = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)];
            } else {
                template.thumbnail = nil;
            }
            if (sqlite3_column_text(stmt, 4)) {
                template.category = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
            } else {
                template.category = @"";
            }
            if (sqlite3_column_int(stmt, 5)) {
                template.recommendation = sqlite3_column_int(stmt, 5);
            } else {
                template.recommendation = 0;
            }
            [templates addObject:template];
        }
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return templates;

}

//error handling
- (void)ErrorReport: (const char *)item
{
    char *errorMsg;
    
    if (sqlite3_exec(_database, item, NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"%@ ok.",[NSString stringWithUTF8String:item]);
    }
    else
    {
        NSLog(@"error: %s",errorMsg);
        sqlite3_free(errorMsg);
    }
}
@end
