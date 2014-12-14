//
//  HomeTemplateContentView.m
//  NetworkTest
//
//  Created by Leading Chen on 14/11/27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "HomeTemplateContentView.h"
#import "ColorHandler.h"
#import "ImageControl.h"

@implementation HomeTemplateContentView {
    UITapGestureRecognizer *tapGestureRecognizer;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self initialize];
    }
    return self;
}

- (void)buildView {
    [self setImage:_backgroundPic];
    self.layer.shadowOpacity = 0.25f;
    self.layer.shadowColor = [ColorHandler colorWithHexString:@"#000000"].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);


    float ctlWidth = 62;
    float ctlHeight = 97;
    UIScrollView *templateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 127, self.bounds.size.width, ctlHeight)];
    templateScrollView.contentSize = CGSizeMake(15+(ctlWidth+10)*[_templateArray count], ctlHeight);
    templateScrollView.scrollEnabled = YES;  //ScrollView cannot be scrolled!!
    templateScrollView.showsHorizontalScrollIndicator = NO;
    templateScrollView.showsVerticalScrollIndicator = NO;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aaa)];
    
    for (int i =0;i<[_templateArray count];i++) {
        TemplateInfo *template = (TemplateInfo *)[_templateArray objectAtIndex:i];
        ImageControl *ctl = [[ImageControl alloc] initWithFrame:CGRectMake(15+i*(ctlWidth+10), 0, ctlWidth, ctlHeight)];
        ctl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
        ctl.controlID = template.ID;
        ctl.template = template;
        [ctl addTarget:self action:@selector(chooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
        [ctl setUserInteractionEnabled:YES];

        ctl.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 60, 95)];
        ctl.imageView.image = [UIImage imageWithData:template.thumbnail];
        [ctl addSubview:ctl.imageView];
        [templateScrollView addSubview:ctl];
    }
    [self addSubview:templateScrollView];
    //[self addGestureRecognizer:tapGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

- (void)aaa {
    NSLog(@"aaa");
}

- (void)chooseTemplate:(ImageControl *)control {
    [self.delegate chooseTemplate:control.template];
}

@end
