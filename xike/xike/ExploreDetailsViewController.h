//
//  ExploreDetailsViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-23.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeoplePickerViewController.h"

@interface ExploreDetailsViewController : UIViewController <UIWebViewDelegate,PeoplePickerViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *desc;

@end
