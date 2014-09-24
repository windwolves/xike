//
//  CanlendarView.h
//  xike
//
//  Created by Leading Chen on 14-9-2.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CanlendarViewDelegate <NSObject>

- (void)refineDateView;
- (void)restoreDateView;

@end

@interface CanlendarView : UIView
@property (nonatomic, strong) NSDateComponents *month;
@property (nonatomic, strong) NSString *dateSelected;
@property (nonatomic, assign) BOOL daySelected;
@property (nonatomic, strong) id <CanlendarViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withMonth:(NSDateComponents*)month;
- (void)createDaysButton;
@end
