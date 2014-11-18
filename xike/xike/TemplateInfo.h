//
//  TemplateInfo.h
//  xike
//
//  Created by Leading Chen on 14-9-27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateInfo : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSData *thumbnail;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) float recommendation;

@end
