//
//  ShareViewController.h
//  xike
//
//  Created by Leading Chen on 15/1/25.
//  Copyright (c) 2015年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageControl.h"
enum {
    WXTimeLine = 1,
    WXSession = 2,
    Email = 3,
    SinaWB = 4,
    SMS = 5
};

@protocol ShareViewControllerDelegate <NSObject>

- (void)share:(NSInteger)type;

@end

@interface ShareViewController : UIViewController
@property (nonatomic, strong) id<ShareViewControllerDelegate> delegate;

@end
