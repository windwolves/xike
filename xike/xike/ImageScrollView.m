//
//  ImageScrollView.m
//  NetworkTest
//
//  Created by Leading Chen on 14/10/29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ImageScrollView.h"

@implementation ImageScrollView {
    UIScrollView *scroll;
    UIPageControl *pageControl;
    NSTimer *autoScrollTimer;
    NSInteger count;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self initialize];
    }
    return self;
}

- (void)initializeWith:(NSArray *)imageArray {
    count = [imageArray count];
    //ScrollView
    scroll = [[UIScrollView alloc] initWithFrame:self.frame];
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.directionalLockEnabled = YES;
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * count, scroll.frame.size.height);
    scroll.contentInset = UIEdgeInsetsZero;
    scroll.delegate = self;
    
    [self addSubview:scroll];
    
    //PageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
    pageControl.numberOfPages = count;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    
    //Set Image
    CGFloat startX = scroll.bounds.origin.x;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    for (int i=0; i<count; i++) {
        startX = i*width;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, 0, width, height)];
        imageView.image = [imageArray objectAtIndex:i];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        [scroll addSubview:imageView];
    }
    
    
}


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    UIImageView *imageView = (UIImageView *)sender.view;
    [_delegate didChooseImageView:imageView];
    
}

#pragma mark - auto scroll
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        if (!autoScrollTimer || !autoScrollTimer.isValid) {
            autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
        }
    } else {
        if (autoScrollTimer && autoScrollTimer.isValid) {
            [autoScrollTimer invalidate];
            autoScrollTimer = nil;
        }
    }
}

- (void)setScrollInterval:(NSUInteger)scrollInterval
{
    _scrollInterval = scrollInterval;
    
    if (autoScrollTimer && autoScrollTimer.isValid) {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }
    
    autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
}

- (void)handleScrollTimer:(NSTimer *)timer
{
    if (count == 0) {
        return;
    }
    
    NSInteger currentPage = pageControl.currentPage;
    NSInteger nextPage = currentPage + 1;
    if (nextPage == count) {
        nextPage = 0;
    }
    
    BOOL animated = YES;
    if (nextPage == 0) {
        animated = NO;
    }
    
    UIImageView *imageView = (UIImageView *)[scroll viewWithTag:(nextPage)];
    [scroll scrollRectToVisible:imageView.frame animated:animated];
    
    pageControl.currentPage = nextPage;
}


#pragma mark - scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // when user scrolls manually, stop timer and start timer again to avoid next scroll immediatelly
    if (autoScrollTimer && autoScrollTimer.isValid) {
        [autoScrollTimer invalidate];
    }
    autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
    
    // update UIPageControl
    CGRect visiableRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.bounds.size.width, scrollView.bounds.size.height);
    NSInteger currentIndex = 0;
    for (UIImageView *imageView in scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            if (CGRectContainsRect(visiableRect, imageView.frame)) {
                currentIndex = imageView.tag;
                break;
            }
        }
    }
    
    pageControl.currentPage = currentIndex;
}


@end
