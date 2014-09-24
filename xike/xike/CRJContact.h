//
//  CRJContact.h
//  Qing
//
//  Created by Leading Chen on 14-6-21.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRJContact : NSObject
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSString *)fullName;
- (NSString *)sortedName;
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, strong) NSString *sortedName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *dateUpdated;

@end
