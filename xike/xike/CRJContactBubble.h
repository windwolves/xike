//
//  CRJContactBubble.h
//  Qing
//
//  Created by Leading Chen on 14-6-21.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CRJBubbleColor.h"

@class CRJContactBubble;

@protocol CRJContactBubbleDelegate <NSObject>

- (void)contactBubbleWasSelected:(CRJContactBubble *)contactBubble;
- (void)contactBubbleWasUnSelected:(CRJContactBubble *)contactBubble;
- (void)contactBubbleShouldBeRemoved:(CRJContactBubble *)contactBubble;

@end

@interface CRJContactBubble : UIView <UITextViewDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextView *textView; // used to capture keyboard touches when view is selected
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) id <CRJContactBubbleDelegate>delegate;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) CRJBubbleColor *color;
@property (nonatomic, strong) CRJBubbleColor *selectedColor;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name
             color:(CRJBubbleColor *)color
     selectedColor:(CRJBubbleColor *)selectedColor;

- (void)select;
- (void)unSelect;
- (void)setFont:(UIFont *)font;

@end
