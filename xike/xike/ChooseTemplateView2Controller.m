//
//  ChooseTemplateView2Controller.m
//  xike
//
//  Created by Leading Chen on 14/12/10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ChooseTemplateView2Controller.h"
#import "ColorHandler.h"
#import "TemplateInfo.h"
#import "ImageControl.h"
#import "CreateNewEventViewController.h"
#import "CreateGreetingCardViewController.h"
#import "CreateInvitationViewController.h"

@interface ChooseTemplateView2Controller ()

@end

@implementation ChooseTemplateView2Controller {
    UIView *categorySectionView;
    UIView *sectionIndicator;
    UIView *categoryView_1;
    UIView *categoryView_2;
    UIView *categoryView_3;
    UIView *categoryView_4;
    UILabel *categoryLable_1;
    UILabel *categoryLable_2;
    UILabel *categoryLable_3;
    UILabel *categoryLable_4;
    NSInteger sectionFlag;
    float sectionWidth;
    float sectionHeight;
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // _createItem = @"Invitation";
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    if ([_createItem isEqualToString:@"GreetingCard"]) {
        [self.navigationItem setTitle:@"贺卡"];
        [self buildGreetingCardTemplateView];
    } else if ([_createItem isEqualToString:@"Invitation"]) {
        [self.navigationItem setTitle:@"邀请函"];
        [self buildInvitationTemplateView];
    }
    
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    
    //Gesture
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];

    [self.view addGestureRecognizer:swipeGestureLeft];
    [self.view addGestureRecognizer:swipeGestureRight];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        UIControl *ctl = [UIControl new];
        ctl.tag = sectionFlag +1;
        [self changeSection:ctl];
    } else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        UIControl *ctl = [UIControl new];
        ctl.tag = sectionFlag - 1;
        [self changeSection:ctl];
    }
}

- (void)returnBtnClicked {
    if (categoryView_1) {
        [categoryView_1 removeFromSuperview];
    }
    if (categoryView_2) {
        [categoryView_2 removeFromSuperview];
    }
    if (categoryView_3) {
        [categoryView_3 removeFromSuperview];
    }
    if (categoryView_4) {
        [categoryView_4 removeFromSuperview];
    }
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)buildGreetingCardTemplateView {
    //section view
    categorySectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 41)];
    categorySectionView.backgroundColor = [ColorHandler colorWithHexString:@"ffffff"];
    categorySectionView.backgroundColor = [ColorHandler colorWithHexString:@"ffffff"];
    [self.view addSubview:categorySectionView];
    sectionWidth = categorySectionView.bounds.size.width/2;
    sectionHeight = categorySectionView.bounds.size.height;
    UIControl *categoryCtl_1 = [self buildCategoryControlWith:CGRectMake(0*sectionWidth, 0, sectionWidth, sectionHeight) :1];
    UIControl *categoryCtl_2 = [self buildCategoryControlWith:CGRectMake(1*sectionWidth, 0, sectionWidth, sectionHeight) :2];
    categoryLable_1 = [self buildCategoryLabelWith:CGRectMake((sectionWidth-24)/2, 0, 24, sectionHeight) :@"新年春节"];
    categoryLable_2 = [self buildCategoryLabelWith:CGRectMake((sectionWidth-24)/2, 0, 24, sectionHeight) :@"情人佳节"];
    [categoryCtl_1 addSubview:categoryLable_1];
    [categoryCtl_2 addSubview:categoryLable_2];
    [categorySectionView addSubview:categoryCtl_1];
    [categorySectionView addSubview:categoryCtl_2];
    categoryLable_1.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    sectionFlag = 1;
    sectionIndicator = [[UIView alloc] initWithFrame:CGRectMake((sectionWidth-90)/2, 39, 90, 2)];
    sectionIndicator.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    [categorySectionView addSubview:sectionIndicator];
    
    //set template info;
    TemplateInfo *info_1 = [self buildTemplateInfoWith:[UIImage imageNamed:@"Christmas_1_362_570.jpg"] :@"7095bc04-0949-4985-801e-e9340c9e756c"];
    TemplateInfo *info_2 = [self buildTemplateInfoWith:[UIImage imageNamed:@"Christmas_2_362_570.jpg"] :@"9adabeb9-9405-4d9e-91ce-a5608c79934a"];//sd2
    TemplateInfo *info_3 = [self buildTemplateInfoWith:[UIImage imageNamed:@"Christmas_3_362_570.jpg"] :@"61e744e8-430b-4d7a-841b-d34caaf49a36"];
    TemplateInfo *info_4 = [self buildTemplateInfoWith:[UIImage imageNamed:@"Christmas_4_362_570.jpg"] :@"cb99c1f7-3dc4-4848-b080-296ed0a4c254"];
    TemplateInfo *info_5 = [self buildTemplateInfoWith:[UIImage imageNamed:@"NewYearDay_1_362_570.jpg"] :@"c961aaf3-0155-416c-8e84-3b5216e7e177"];
    TemplateInfo *info_6 = [self buildTemplateInfoWith:[UIImage imageNamed:@"NewYearDay_2_362_570.jpg"] :@"3a7cb5ca-c5b3-4afc-9c01-1633a1092da5"];//yd1
    TemplateInfo *info_7 = [self buildTemplateInfoWith:[UIImage imageNamed:@"NewYearDay_3_362_570.jpg"] :@"68a69ccb-3c46-4982-a83d-1e194a12cfb2"];
    TemplateInfo *info_8 = [self buildTemplateInfoWith:[UIImage imageNamed:@"NewYearDay_4_362_570.jpg"] :@"fa4af1c2-8aaa-483a-b680-ecfaa64f3d8b"];
    NSArray *templateArray_1 = @[info_1,info_2,info_3,info_4];
    NSArray *templateArray_2 = @[info_5,info_6,info_7,info_8];
    
    //build category view
    categoryView_1 = [self buildCategoryViewWith:templateArray_1];
    categoryView_2 = [self buildCategoryViewWith:templateArray_2];
    [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width, 115, 283, 443)];
    [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width, 115, 283, 443)];
    [self.view addSubview:categoryView_1];
    [self.view addSubview:categoryView_2];
    
}

- (void)buildInvitationTemplateView {
    //section View
    categorySectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 41)];
    categorySectionView.backgroundColor = [ColorHandler colorWithHexString:@"ffffff"];
    [self.view addSubview:categorySectionView];
    sectionWidth = categorySectionView.bounds.size.width/4;
    sectionHeight = categorySectionView.bounds.size.height;
    UIControl *categoryCtl_1 = [self buildCategoryControlWith:CGRectMake(0*sectionWidth, 0, sectionWidth, sectionHeight) :1];
    UIControl *categoryCtl_2 = [self buildCategoryControlWith:CGRectMake(1*sectionWidth, 0, sectionWidth, sectionHeight) :2];
    UIControl *categoryCtl_3 = [self buildCategoryControlWith:CGRectMake(2*sectionWidth, 0, sectionWidth, sectionHeight) :3];
    UIControl *categoryCtl_4 = [self buildCategoryControlWith:CGRectMake(3*sectionWidth, 0, sectionWidth, sectionHeight) :4];
    categoryLable_1 = [self buildCategoryLabelWith:CGRectMake((sectionWidth-36)/2, 0, 36, sectionHeight) :@"动物不太凶猛"];
    categoryLable_2 = [self buildCategoryLabelWith:CGRectMake((sectionWidth-24)/2, 0, 24, sectionHeight) :@"闷骚青年"];
    categoryLable_3 = [self buildCategoryLabelWith:CGRectMake((sectionWidth-24)/2, 0, 24, sectionHeight) :@"好色人生"];
    categoryLable_4 = [self buildCategoryLabelWith:CGRectMake((sectionWidth-24)/2, 0, 24, sectionHeight) :@"多面怪兽"];
    [categoryCtl_1 addSubview:categoryLable_1];
    [categoryCtl_2 addSubview:categoryLable_2];
    [categoryCtl_3 addSubview:categoryLable_3];
    [categoryCtl_4 addSubview:categoryLable_4];
    [categorySectionView addSubview:categoryCtl_1];
    [categorySectionView addSubview:categoryCtl_2];
    [categorySectionView addSubview:categoryCtl_3];
    [categorySectionView addSubview:categoryCtl_4];
    categoryLable_1.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    sectionFlag = 1;
    sectionIndicator = [[UIView alloc] initWithFrame:CGRectMake((sectionWidth-50)/2, 39, 50, 2)];
    sectionIndicator.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    [categorySectionView addSubview:sectionIndicator];
    
    //set template info;
    //these should be fetched from database;
    TemplateInfo *info_1 = [self buildTemplateInfoWith:[UIImage imageNamed:@"y001_362_570.jpg"] :@"36c7f4b4-dbe7-4886-9c87-f8ac6679a9ee"];
    TemplateInfo *info_2 = [self buildTemplateInfoWith:[UIImage imageNamed:@"y002_362_570.jpg"] :@"69639840-f7a3-4b96-97db-c4128ce6c358"];
    TemplateInfo *info_3 = [self buildTemplateInfoWith:[UIImage imageNamed:@"y003_362_570.jpg"] :@"68290803-d3ad-428e-9307-f8382be5cc83"];
    TemplateInfo *info_4 = [self buildTemplateInfoWith:[UIImage imageNamed:@"y004_362_570.jpg"] :@"c3c931ea-c690-43d1-ae28-9863bad7799b"];
    TemplateInfo *info_5 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x001_362_570.jpg"] :@"544331a9-e6e5-41c1-9212-6fcf6f3b3ebc"];
    TemplateInfo *info_6 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x002_362_570.jpg"] :@"9f42133f-929f-4998-9bbd-315effcb2c38"];
    TemplateInfo *info_7 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x003_362_570.jpg"] :@"300a3507-751a-4fbf-8187-a82d1e68860c"];
    TemplateInfo *info_8 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x004_362_570.jpg"] :@"22b7fd9f-74d7-44f2-87ef-5af810bed314"];
    TemplateInfo *info_9 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x005_362_570.jpg"] :@"71bf36af-bb1e-42d5-a233-471ba7dbb54c"];
    TemplateInfo *info_10 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x006_362_570.jpg"] :@"8d7c8889-d3c1-4384-9edd-5c9691c2e790"];
    TemplateInfo *info_11 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x007_362_570.jpg"] :@"08d3b3f3-cef5-4c9f-bee9-29371dd180ba"];
    TemplateInfo *info_12 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x008_362_570.jpg"] :@"68868dc2-a7ab-4866-b27e-a5679aee2e25"];
    TemplateInfo *info_13 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x009_362_570.jpg"] :@"49e81bde-d51e-485d-be42-bbb269330081"];
    TemplateInfo *info_14 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x010_362_570.jpg"] :@"5fbbd474-2ecd-4054-add4-e994ddda128e"];
    TemplateInfo *info_15 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x011_362_570.jpg"] :@"f127e1e0-0569-439c-ad03-2c980ed2f55a"];
    TemplateInfo *info_16 = [self buildTemplateInfoWith:[UIImage imageNamed:@"x012_362_570.jpg"] :@"27deb988-009b-431d-80cf-ba1349cef19c"];
    NSArray *templateArray_1 = @[info_1,info_2,info_3,info_4];
    NSArray *templateArray_2 = @[info_5,info_6,info_7,info_8];
    NSArray *templateArray_3 = @[info_9,info_10,info_11,info_12];
    NSArray *templateArray_4 = @[info_13,info_14,info_15,info_16];
    
    //build category view
    categoryView_1 = [self buildCategoryViewWith:templateArray_1];
    categoryView_2 = [self buildCategoryViewWith:templateArray_2];
    categoryView_3 = [self buildCategoryViewWith:templateArray_3];
    categoryView_4 = [self buildCategoryViewWith:templateArray_4];
    [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width, 115, 283, 443)];
    [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width, 115, 283, 443)];
    [categoryView_3 setFrame:CGRectMake(18+2*self.view.bounds.size.width, 115, 283, 443)];
    [categoryView_4 setFrame:CGRectMake(18+3*self.view.bounds.size.width, 115, 283, 443)];
    [self.view addSubview:categoryView_1];
    [self.view addSubview:categoryView_2];
    [self.view addSubview:categoryView_3];
    [self.view addSubview:categoryView_4];
    
}

- (TemplateInfo *)buildTemplateInfoWith:(UIImage *)image :(NSString *)ID {
    TemplateInfo *info = [TemplateInfo new];
    info.thumbnail = UIImagePNGRepresentation(image);
    info.ID = ID;
    return info;
}

- (UIView *)buildCategoryViewWith:(NSArray *)templateArray {
    float templateWidth = 137;
    float templateHeight = 217;
    float h_space = 9;
    float v_space = 9;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(18, 115, templateWidth*2+h_space, templateHeight*2+v_space)];
    TemplateInfo *template_1 = [templateArray objectAtIndex:0];
    TemplateInfo *template_2 = [templateArray objectAtIndex:1];
    TemplateInfo *template_3 = [templateArray objectAtIndex:2];
    TemplateInfo *template_4 = [templateArray objectAtIndex:3];
    
    ImageControl *templateCtl_1 = [self buildTemplateControlWith:CGRectMake(0, 0, templateWidth, templateHeight) :template_1];
    ImageControl *templateCtl_2 = [self buildTemplateControlWith:CGRectMake(templateWidth+h_space, 0, templateWidth, templateHeight) :template_2];
    ImageControl *templateCtl_3 = [self buildTemplateControlWith:CGRectMake(0, templateHeight+v_space, templateWidth, templateHeight) :template_3];
    ImageControl *templateCtl_4 = [self buildTemplateControlWith:CGRectMake(templateWidth+h_space, templateHeight+v_space, templateWidth, templateHeight) :template_4];
    
    [view addSubview:templateCtl_1];
    [view addSubview:templateCtl_2];
    [view addSubview:templateCtl_3];
    [view addSubview:templateCtl_4];
    
    return view;
}

- (ImageControl *)buildTemplateControlWith:(CGRect)frame :(TemplateInfo *)info {
    ImageControl *ctl = [[ImageControl alloc] initWithFrame:frame];
    ctl.template = info;
    [ctl addTarget:self action:@selector(didChooseTemplate:) forControlEvents:UIControlEventTouchUpInside];
    ctl.imageView = [[UIImageView alloc] initWithFrame:ctl.bounds];
    ctl.imageView.image = [UIImage imageWithData:info.thumbnail];;
    [ctl addSubview:ctl.imageView];
    ctl.controlID = info.ID;
    
    return ctl;
}

- (UIControl *)buildCategoryControlWith:(CGRect)frame :(NSInteger)tag {
    UIControl *control = [[UIControl alloc] initWithFrame:frame];
    control.tag = tag;
    [control addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    return control;
}


- (UILabel *)buildCategoryLabelWith:(CGRect)frame :(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = [UIFont systemFontOfSize:12];
    label.text = text;
    label.textColor = [ColorHandler colorWithHexString:@"#413445"];
    
    return label;
}

- (void)changeSection:(UIControl *)section {
    NSInteger moveDistance = (sectionFlag-section.tag)*self.view.bounds.size.width;
    if ([_createItem isEqualToString:@"GreetingCard"]) {
        if (section.tag == sectionFlag) {
            return;
        } else {
            categoryLable_1.textColor = [ColorHandler colorWithHexString:@"#413445"];
            categoryLable_2.textColor = [ColorHandler colorWithHexString:@"#413445"];
            if (section.tag == 1) {
                categoryLable_1.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                sectionFlag = 1;
                [sectionIndicator setFrame:CGRectMake((sectionWidth-90)/2, 39, 90, 2)];
                [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width, 115, 283, 443)];
            } else if (section.tag == 2) {
                categoryLable_2.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                sectionFlag = 2;
                [sectionIndicator setFrame:CGRectMake((sectionWidth-90)/2+1*sectionWidth, 39, 90, 2)];
                [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width-1*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width-1*self.view.bounds.size.width, 115, 283, 443)];
            }
            [self moveAmimationWith:moveDistance];
        }
    } else if ([_createItem isEqualToString:@"Invitation"]) {
        if (section.tag == sectionFlag) {
            return;
        } else {
            categoryLable_1.textColor = [ColorHandler colorWithHexString:@"#413445"];
            categoryLable_2.textColor = [ColorHandler colorWithHexString:@"#413445"];
            categoryLable_3.textColor = [ColorHandler colorWithHexString:@"#413445"];
            categoryLable_4.textColor = [ColorHandler colorWithHexString:@"#413445"];
            if (section.tag == 1) {
                categoryLable_1.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                sectionFlag = 1;
                [sectionIndicator setFrame:CGRectMake((sectionWidth-50)/2, 39, 50, 2)];
                [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_3 setFrame:CGRectMake(18+2*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_4 setFrame:CGRectMake(18+3*self.view.bounds.size.width, 115, 283, 443)];
            } else if (section.tag == 2) {
                categoryLable_2.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                sectionFlag = 2;
                [sectionIndicator setFrame:CGRectMake((sectionWidth-50)/2+1*sectionWidth, 39, 50, 2)];
                [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width-1*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width-1*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_3 setFrame:CGRectMake(18+2*self.view.bounds.size.width-1*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_4 setFrame:CGRectMake(18+3*self.view.bounds.size.width-1*self.view.bounds.size.width, 115, 283, 443)];
            } else if (section.tag == 3) {
                categoryLable_3.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                sectionFlag = 3;
                [sectionIndicator setFrame:CGRectMake((sectionWidth-50)/2+2*sectionWidth, 39, 50, 2)];
                [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width-2*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width-2*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_3 setFrame:CGRectMake(18+2*self.view.bounds.size.width-2*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_4 setFrame:CGRectMake(18+3*self.view.bounds.size.width-2*self.view.bounds.size.width, 115, 283, 443)];
            } else if (section.tag == 4) {
                categoryLable_4.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
                sectionFlag = 4;
                [sectionIndicator setFrame:CGRectMake((sectionWidth-50)/2+3*sectionWidth, 39, 50, 2)];
                [categoryView_1 setFrame:CGRectMake(18+0*self.view.bounds.size.width-3*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_2 setFrame:CGRectMake(18+1*self.view.bounds.size.width-3*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_3 setFrame:CGRectMake(18+2*self.view.bounds.size.width-3*self.view.bounds.size.width, 115, 283, 443)];
                [categoryView_4 setFrame:CGRectMake(18+3*self.view.bounds.size.width-3*self.view.bounds.size.width, 115, 283, 443)];
            }
            
            [self moveAmimationWith:moveDistance];
        }
    }
}

- (void)moveAmimationWith:(NSInteger)moveDistance {
    if ([_createItem isEqualToString:@"GreetingCard"]) {
        [sectionIndicator setTransform:CGAffineTransformMakeTranslation(moveDistance/2,0)];
        [categoryView_1 setTransform:CGAffineTransformMakeTranslation(-moveDistance,0)];
        [categoryView_2 setTransform:CGAffineTransformMakeTranslation(-moveDistance,0)];
        
        [UIView animateWithDuration:0.40f animations:^{
            [sectionIndicator setTransform:CGAffineTransformIdentity];
            [categoryView_1 setTransform:CGAffineTransformIdentity];
            [categoryView_2 setTransform:CGAffineTransformIdentity];
        }];
    } else if ([_createItem isEqualToString:@"Invitation"]) {
        [sectionIndicator setTransform:CGAffineTransformMakeTranslation(moveDistance/4,0)];
        [categoryView_1 setTransform:CGAffineTransformMakeTranslation(-moveDistance,0)];
        [categoryView_2 setTransform:CGAffineTransformMakeTranslation(-moveDistance,0)];
        [categoryView_3 setTransform:CGAffineTransformMakeTranslation(-moveDistance,0)];
        [categoryView_4 setTransform:CGAffineTransformMakeTranslation(-moveDistance,0)];
        
        [UIView animateWithDuration:0.40f animations:^{
            [sectionIndicator setTransform:CGAffineTransformIdentity];
            [categoryView_1 setTransform:CGAffineTransformIdentity];
            [categoryView_2 setTransform:CGAffineTransformIdentity];
            [categoryView_3 setTransform:CGAffineTransformIdentity];
            [categoryView_4 setTransform:CGAffineTransformIdentity];
        }];
    }
}

- (void)didChooseTemplate:(ImageControl *)ctl {
    if ([_createItem isEqualToString:@"Invitation"]) {
        CreateInvitationViewController *createInvitationViewController = [CreateInvitationViewController new];
        createInvitationViewController.database = _database;
        createInvitationViewController.user = _user;
        createInvitationViewController.template = [TemplateInfo new];
        createInvitationViewController.template.ID = ctl.controlID;
        createInvitationViewController.isCreate = YES;
        
        [self.navigationController pushViewController:createInvitationViewController animated:YES];
    } else if ([_createItem isEqualToString:@"GreetingCard"]) {
        CreateGreetingCardViewController *createGreetingCardController = [CreateGreetingCardViewController new];
        createGreetingCardController.database = _database;
        createGreetingCardController.user = _user;
        createGreetingCardController.template = [TemplateInfo new];
        createGreetingCardController.template.ID = ctl.controlID;
        createGreetingCardController.theme = (sectionFlag==1)?@"Christmas":@"NewYearDay";
        createGreetingCardController.isCreate = YES;
        [self.navigationController pushViewController:createGreetingCardController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
