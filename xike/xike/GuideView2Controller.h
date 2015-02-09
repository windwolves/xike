//
//  GuideView2Controller.h
//  xike
//
//  Created by Leading Chen on 15/1/28.
//  Copyright (c) 2015年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XikeDatabase.h"
#import "MainView2Controller.h"
#import "UserLogonViewController.h"
#import "GuideViewController.h"


@interface GuideView2Controller : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *backLayerView;
@property (nonatomic, strong) UIImageView *frontLayerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pages;

@property (nonatomic, strong) UserLogonViewController *logonViewController;
@property (nonatomic, strong) MainView2Controller *mainView2Controller;
@property (nonatomic, assign) NSInteger destination;
@end
