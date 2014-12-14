//
//  HomeTemplateContentView.h
//  NetworkTest
//
//  Created by Leading Chen on 14/11/27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateInfo.h"

@protocol HomeTemplateContentViewDelegate <NSObject>

- (void)chooseTemplate:(TemplateInfo *)template;

@end

@interface HomeTemplateContentView : UIImageView
@property (nonatomic, strong) UIImage *backgroundPic;
@property (nonatomic, strong) NSMutableArray *templateArray;
@property (nonatomic, strong) id <HomeTemplateContentViewDelegate> delegate;

- (void)buildView;
@end
