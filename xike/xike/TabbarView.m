//
//  TabbarView.m
//  xike
//
//  Created by Leading Chen on 14-8-28.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "TabbarView.h"
#import "ColorHandler.h"

@implementation TabbarView 

@synthesize firstBtn,secondBtn,thirdBtn,delegate;

- (id)initWithFrame:(CGRect)frame withSelectedTag:(NSInteger)selectTag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        _g_selectedTag=selectTag;
        UIImageView *btnImgView;
        
        //discover btn
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recommend_off"] highlightedImage:[UIImage imageNamed:@"recommend_on"]];
        btnImgView.frame = CGRectMake(41, 7, 24, 35);
        firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [firstBtn setFrame:CGRectMake(0, 0, 106, 48)];
        firstBtn.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
        firstBtn.alpha = 0.9f;
        [firstBtn setTag:1];
        [firstBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [firstBtn addSubview:btnImgView];
        [self addSubview:firstBtn];
        //((UIImageView *)firstBtn.subviews[0]).highlighted=YES; //make the firstBtn highlighted at the beginning
        
        //create btn
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create"]];
        btnImgView.frame = CGRectMake(41, 7, 25, 35);
        secondBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [secondBtn setFrame:CGRectMake(106, 0, 108, 48)];
        secondBtn.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
        secondBtn.alpha = 0.9f;
        [secondBtn setTag:2];
        [secondBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addSubview:btnImgView];
        [self addSubview:secondBtn];
        
        //personal btn
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myEvents_off"] highlightedImage:[UIImage imageNamed:@"myEvents_on"]];
        btnImgView.frame = CGRectMake(43, 7, 20, 35);
        thirdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [thirdBtn setFrame:CGRectMake(214, 0, 106, 48)];
        thirdBtn.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
        thirdBtn.alpha = 0.9f;
        [thirdBtn setTag:3];
        [thirdBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [thirdBtn addSubview:btnImgView];
        [self addSubview:thirdBtn];
        if (_g_selectedTag == 1) {
            ((UIImageView *)firstBtn.subviews[0]).highlighted=YES;
        } else if (_g_selectedTag == 3) {
            ((UIImageView *)thirdBtn.subviews[0]).highlighted=YES; 
        }
        
    }
    return self;
}

- (void)buttonClickAction:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    if(_g_selectedTag==btn.tag) {
        return;
    } else {
        _g_selectedTag=btn.tag;
    }
    
    if (firstBtn.tag!=btn.tag) {
        ((UIImageView *)firstBtn.subviews[0]).highlighted=NO;
    }
    
    if (secondBtn.tag!=btn.tag) {
        ((UIImageView *)secondBtn.subviews[0]).highlighted=NO;
    }
    
    if (thirdBtn.tag!=btn.tag) {
        
        ((UIImageView *)thirdBtn.subviews[0]).highlighted=NO;
    }
    
    [self imgAnimate:btn];
    
    ((UIImageView *)btn.subviews[0]).highlighted=YES;
    
    [self callButtonAction:btn];

}

-(void)callButtonAction:(UIButton *)sender{
    NSUInteger value = sender.tag;
    if (value==1) {
        [self.delegate FirstBtnClick];
    }
    if (value==2) {
        [self.delegate SecondBtnClick];
    }
    if (value==3) {
        [self.delegate ThirdBtnClick];
    }
}

- (void)imgAnimate:(UIButton*)btn{
    
    UIView *view=btn.subviews[0];
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);

     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
              
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);

               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
