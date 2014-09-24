//
//  PeopleInfo.m
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "PeopleInfo.h"

@implementation PeopleInfo

- (id)init {
    self = [super init];
    return self;
}

- (id) initWithID:(NSString *)user_id Name:(NSString *)name Phone:(NSString *)phone Photo:(NSData *)photo {
    self = [super init];
    self.user_id = user_id;
    self.name = name;
    self.phone = phone;
    self.photo = photo;
    return self;
}

@end
