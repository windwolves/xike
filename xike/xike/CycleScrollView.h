//
//  CycleScrollView.h
//  xike
//
//  Created by Leading Chen on 14-9-4.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CycleScrollViewDelegate;
@protocol CycleScrollViewDatasource;

@interface CycleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id <CycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id <CycleScrollViewDelegate> delegate;

- (void)setCurrentSelectPage:(NSInteger)selectPage; //设置初始化页数
- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index;
- (void)scrollviewDidChangeNumber;

@end

@protocol CycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages:(CycleScrollView*)scrollView;
- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(CycleScrollView*)scrollView;

@end