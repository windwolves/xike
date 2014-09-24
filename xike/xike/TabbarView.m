//
//  TabbarView.m
//  xike
//
//  Created by Leading Chen on 14-8-28.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "TabbarView.h"
#import "ColorHandler.h"

@implementation TabbarView {
    NSInteger g_selectedTag;
}

@synthesize firstBtn,secondBtn,thirdBtn,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        g_selectedTag=3;
        UIImageView *btnImgView;
        
        //discover btn
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_off"] highlightedImage:[UIImage imageNamed:@"discover_on"]];
        btnImgView.frame = CGRectMake(40, 17, 24, 15);
        firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [firstBtn setFrame:CGRectMake(0, 0, 106, 49)];
        firstBtn.backgroundColor = [ColorHandler colorWithHexString:@"#413445"];
        firstBtn.layer.shadowOffset = CGSizeMake(0, 3);
        firstBtn.layer.shadowRadius = 1.0;
        firstBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        [firstBtn setTag:1];
        [firstBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [firstBtn addSubview:btnImgView];
        [self addSubview:firstBtn];
        //((UIImageView *)firstBtn.subviews[0]).highlighted=YES; //make the firstBtn highlighted at the beginning
        
        //create btn
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_event"]];
        btnImgView.frame = CGRectMake(40, 10, 29, 30);
        secondBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [secondBtn setFrame:CGRectMake(106, 0, 108, 49)];
        secondBtn.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
        secondBtn.layer.shadowOffset = CGSizeMake(0, 3);
        secondBtn.layer.shadowRadius = 1.0;
        secondBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        [secondBtn setTag:2];
        [secondBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addSubview:btnImgView];
        [self addSubview:secondBtn];
        
        //personal btn
        btnImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_off"] highlightedImage:[UIImage imageNamed:@"personal_on"]];
        btnImgView.frame = CGRectMake(45, 16, 15, 17);
        thirdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [thirdBtn setFrame:CGRectMake(214, 0, 106, 49)];
        thirdBtn.backgroundColor = [ColorHandler colorWithHexString:@"#413445"];
        thirdBtn.layer.shadowOffset = CGSizeMake(0, 3);
        thirdBtn.layer.shadowRadius = 1.0;
        thirdBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        [thirdBtn setTag:3];
        [thirdBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [thirdBtn addSubview:btnImgView];
        [self addSubview:thirdBtn];
        ((UIImageView *)thirdBtn.subviews[0]).highlighted=YES; //make the thirdBtn highlighted at the beginning
    }
    return self;
}

- (void)buttonClickAction:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    if(g_selectedTag==btn.tag) {
        return;
    } else {
        g_selectedTag=btn.tag;
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
