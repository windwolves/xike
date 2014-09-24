//
//  CRJContactPickerView.h
//  Qing
//
//  Created by Leading Chen on 14-6-21.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRJContactBubble.h"
@class CRJContactPickerView;

@protocol CRJContactPickerViewDelegate <NSObject>

- (void)contactPickerTextViewDidChange:(NSString *)textViewText;
- (void)contactPickerDidRemoveContact:(id)contact;
- (void)contactPickerDidResize:(CRJContactPickerView *)contactPickerView;
- (void)contactPickerTextViewDidBeginEditing;

@end

@interface CRJContactPickerView : UIView <UITextViewDelegate,UIScrollViewDelegate,CRJContactBubbleDelegate>
@property (nonatomic, strong) CRJContactBubble *selectedContactBubble;
@property (nonatomic, assign) IBOutlet id <CRJContactPickerViewDelegate> delegate;
@property (nonatomic, assign) BOOL limitToOne;
@property (nonatomic, assign) CGFloat viewPadding;
@property (nonatomic, strong) UIFont *font;

- (void)addContact:(id)contact withName:(NSString *)name;
- (void)removeContact:(id)contact;
- (void)removeAllContacts;
- (void)setPlaceholderString:(NSString *)placeholderString;
- (void)disableDropShadow;
- (void)resignKeyboard;
- (void)setBubbleColor:(CRJBubbleColor *)color selectedColor:(CRJBubbleColor *)selectedColor;

@end
