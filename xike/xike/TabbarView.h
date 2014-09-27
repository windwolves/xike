//
//  TabbarView.h
//  xike
//
//  Created by Leading Chen on 14-8-28.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabbarViewDelegate <NSObject>
@required
-(void)FirstBtnClick;
-(void)SecondBtnClick;
-(void)ThirdBtnClick;
@end

@interface TabbarView : UIView
@property (nonatomic, strong) id <TabbarViewDelegate> delegate;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, assign) NSInteger g_selectedTag;

- (void)buttonClickAction:(id)sender;
- (id)initWithFrame:(CGRect)frame withSelectedTag:(NSInteger)selectTag;

@end
