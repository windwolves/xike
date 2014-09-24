//
//  PeopleInfo.h
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleInfo : NSObject
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSData *photo;

- (id)initWithID:(NSString *)user_id Name:(NSString *)name Phone:(NSString *)phone Photo:(NSData *)photo;
@end
