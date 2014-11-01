//
//  ImageScrollView.h
//  NetworkTest
//
//  Created by Leading Chen on 14/10/29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>

- (void)didChooseImageView:(UIImageView *)imageView;

@end

@interface ImageScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) NSUInteger scrollInterval;
@property (nonatomic, strong) id <ImageScrollViewDelegate> delegate;

- (void)initializeWith:(NSArray *)imageArray;;


@end
