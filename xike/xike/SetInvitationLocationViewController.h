//
//  SetInvitationLocationViewController.h
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetInvitationLocationViewControllerDelegate <NSObject>

- (void)didFinishSetLocation:(NSString *)location;

@end

@interface SetInvitationLocationViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) UITextView *locationTextView;
@property (nonatomic, strong) id <SetInvitationLocationViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *location;
@end
