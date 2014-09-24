//
//  CycleScrollView.m
//  xike
//
//  Created by Leading Chen on 14-9-4.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CycleScrollView.h"
#import "ColorHandler.h"

@implementation CycleScrollView {
    NSInteger totalPages;
    NSInteger curPage;
    NSMutableArray *curViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, (self.bounds.size.height/5)*7);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(0, (self.bounds.size.height/5));
        
        [self addSubview:_scrollView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//设置初始化页数
- (void)setCurrentSelectPage:(NSInteger)selectPage
{
    curPage = selectPage;
}

- (void)setDataource:(id <CycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    totalPages = [_datasource numberOfPages:self];
    if (totalPages == 0) {
        return;
    }
    [self loadData];
}

- (void)loadData
{
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 7; i++) {
        UIView *v = [curViews objectAtIndex:i];
        v.frame = CGRectOffset(v.frame, 0, v.frame.size.height * i );
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake( 0, (self.bounds.size.height/5) )];
}


- (void)getDisplayImagesWithCurpage:(int)page {
    int pre1 = [self validPageValue:curPage-1];
    int pre2 = [self validPageValue:curPage];
    int pre3 = [self validPageValue:curPage+1];
    int pre4 = [self validPageValue:curPage+2];
    int pre5 = [self validPageValue:curPage+3];
    int pre = [self validPageValue:curPage+4];
    int last = [self validPageValue:curPage+5];
    
    if (!curViews) {
        curViews = [[NSMutableArray alloc] init];
    }
    
    [curViews removeAllObjects];
    
    [curViews addObject:[_datasource pageAtIndex:pre1 andScrollView:self]];
    [curViews addObject:[_datasource pageAtIndex:pre2 andScrollView:self]];
    [curViews addObject:[_datasource pageAtIndex:pre3 andScrollView:self]];
    [curViews addObject:[_datasource pageAtIndex:pre4 andScrollView:self]];
    [curViews addObject:[_datasource pageAtIndex:pre5 andScrollView:self]];
    [curViews addObject:[_datasource pageAtIndex:pre andScrollView:self]];
    [curViews addObject:[_datasource pageAtIndex:last andScrollView:self]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1 ) value = totalPages - 1;
    if(value == totalPages+1) value = 1;
    if (value == totalPages+2) value = 2;
    if(value == totalPages+3) value = 3;
    if (value == totalPages+4) value = 4;
    if(value == totalPages) value = 0;
    
    return value;
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == curPage) {
        [curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 7; i++) {
            UIView *v = [curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            v.frame = CGRectOffset(v.frame, 0, v.frame.size.height * i);
            [_scrollView addSubview:v];
        }
    }
}


- (void)setAfterScrollShowView:(UIScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    UILabel *twoLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    
    UILabel *currentLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    
    UILabel *threeLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    UILabel *fourLabel = (UILabel*)[[scrollview subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int y = aScrollView.contentOffset.y;
    NSInteger page = aScrollView.contentOffset.y/((self.bounds.size.height/5));
    NSLog(@"第%d页",page);
    
    if (y>2*(self.bounds.size.height/5)) {
        curPage = [self validPageValue:curPage+1];
        [self loadData];
    }
    if (y<=0) {
        curPage = [self validPageValue:curPage-1];
        [self loadData];
    }
    //    //往下翻一张
    //    if(x >= (4*self.frame.size.width)) {
    //        _curPage = [self validPageValue:_curPage+1];
    //        [self loadData];
    //    }
    //
    //    //往上翻
    //    if(x <= 0) {
    //
    //    }
    if (page>1 || page <=0) {
        [self setAfterScrollShowView:aScrollView andCurrentPage:1];
    }
    if ([_delegate respondsToSelector:@selector(scrollviewDidChangeNumber)]) {
        [_delegate scrollviewDidChangeNumber];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_scrollView setContentOffset:CGPointMake(0, (self.bounds.size.height/5)) animated:YES];
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
    if ([_delegate respondsToSelector:@selector(scrollviewDidChangeNumber)]) {
        [_delegate scrollviewDidChangeNumber];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_scrollView setContentOffset:CGPointMake(0, (self.bounds.size.height/5)) animated:YES];
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
    if ([_delegate respondsToSelector:@selector(scrollviewDidChangeNumber)]) {
        [_delegate scrollviewDidChangeNumber];
    }
}

@end
