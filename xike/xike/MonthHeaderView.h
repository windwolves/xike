//
//  MonthHeaderView.h
//  xike
//
//  Created by Leading Chen on 14-9-8.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MonthHeaderView;

@protocol MonthHeaderViewDelegate <NSObject>
- (void)selector:(MonthHeaderView *)valueSelector didSelectRowAtIndex:(NSIndexPath *)indexPath;
@end

@protocol MonthHeaderViewDatasource <NSObject>
- (NSInteger)numberOfRowsInSelector:(MonthHeaderView *)valueSelector;
- (UIView *)selector:(MonthHeaderView *)valueSelector viewForRowAtIndex:(NSInteger) index;
- (CGRect)rectForSelectionInSelector:(MonthHeaderView *)valueSelector;
//- (CGFloat)rowHeightInSelector:(MonthHeaderView *)valueSelector;
- (CGFloat)rowWidthInSelector:(MonthHeaderView *)valueSelector;

@end

@interface MonthHeaderView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) id <MonthHeaderViewDelegate> delegate;
@property (nonatomic, strong) id <MonthHeaderViewDatasource> dataSource;
@property (nonatomic, strong) UITableView *table;
- (void)reloadData;

@end
