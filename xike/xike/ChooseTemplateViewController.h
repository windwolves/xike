//
//  ChooseTemplateViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-9.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInfo.h"
#import "XikeDatabase.h"

@protocol ChooseTemplateViewControllerDelegate <NSObject>


@end

@interface ChooseTemplateViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate,NSURLSessionDataDelegate>
@property (nonatomic, strong) EventInfo *event;
@property (nonatomic, strong) XikeDatabase *database;
@property (nonatomic, strong) id <ChooseTemplateViewControllerDelegate> delegate;


@end
