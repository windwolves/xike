//
//  GreetingInfo.h
//  xike
//
//  Created by Leading Chen on 14/12/9.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeopleInfo.h"
#import "UserInfo.h"
#import "TemplateInfo.h"

@interface GreetingInfo : NSObject
@property (nonatomic, assign) NSInteger *greetingCardID;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *templateID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *defaultContent;
@property (nonatomic, assign) NSInteger send_status;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) TemplateInfo *template;

@end
