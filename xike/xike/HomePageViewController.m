//
//  HomePageViewController.m
//  NetworkTest
//
//  Created by Leading Chen on 14/11/25.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "HomePageViewController.h"
#import "ColorHandler.h"
#import "TemplateInfo.h"
#import "CreateGreetingCardViewController.h"
#import "CreateInvitationViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController {
    UIView *sectionView;
    UIView *sectionIndicator;
    UIView *maskView;
    UIView *createView;
    UIView *navigationBar;
    UIImageView *templateImageView;
    UIControl *invitationCtl;
    UIControl *greetingCardCtl;
    UILabel *invitationLabel;
    UIImageView *invitationLabelView;
    UILabel *greetingCardLabel;
    UIImageView *greetingCardLabelView;
    UIScrollView *invitationView;
    UIScrollView *greetingCardView;
    UIButton *notificationButton;
    UIControl *notificationCtl;
    UIImageView *notificationImageView;
    int sectionFlag;
    TemplateInfo *templateToCreate;
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
}

enum ControlFlag {
    InvitationTag = 1,
    GreetingCardTag = 2,
};

- (void)viewWillAppear:(BOOL)animated {
    //Hide navigationBar and build it by my own
    self.navigationController.navigationBarHidden = YES;
    if (!navigationBar) {
        navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        navigationBar.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
        navigationBar.layer.shadowOpacity = 0;
        [self.view addSubview:navigationBar];
    }
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((navigationBar.bounds.size.width-35)/2, 33, 35, 17)];
    [titleImageView setImage:[[UIImage imageNamed:@"xike_navigationbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navigationBar addSubview:titleImageView];
    
    notificationCtl = [[UIControl alloc] initWithFrame:CGRectMake(270, 28, 36, 30)];
    notificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 16, 20)];
    notificationImageView.image = [[UIImage imageNamed:@"notification_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [notificationCtl addSubview:notificationImageView];
    [notificationCtl addTarget:self action:@selector(popNotificationView) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:notificationCtl];
 
    //notification button
    if ([_database getCountOfUnreadMessage:_user.userID] != 0) {
        notificationImageView.image = [[UIImage imageNamed:@"notification_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        notificationImageView.image = [[UIImage imageNamed:@"notification_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    /*
    if ([_database getCountOfUnreadMessage:_user.userID] != 0) {
        [notificationButton setImage:[[UIImage imageNamed:@"notification_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [notificationButton setImage:[[UIImage imageNamed:@"notification_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    
    //Mask View
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    maskView.backgroundColor = [ColorHandler colorWithHexString:@"#000000"];
    maskView.alpha = 0.8f;
    
    //Gesture
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self buildView];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showInvitationView];
    } else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showGreetingCardView];
    }
}

- (void)popNotificationView {
    [self.delegate popNotificationView];
}

- (void)buildView {
    //section view
    sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 41)];
    sectionView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    sectionView.layer.shadowColor = [ColorHandler colorWithHexString:@"#b2b2b2"].CGColor;
    sectionView.layer.shadowOpacity = 1;
    [self.view addSubview:sectionView];
    sectionIndicator = [[UIView alloc] initWithFrame:CGRectMake((sectionView.bounds.size.width/2-90)/2, 39, 90, 2)];
    sectionIndicator.backgroundColor = [ColorHandler colorWithHexString:@"#1de9B6"];
    [sectionView addSubview:sectionIndicator];
    sectionFlag = GreetingCardTag;
    
    //Invitation Letter
    invitationCtl = [[UIControl alloc] initWithFrame:CGRectMake(sectionView.bounds.size.width/2, 0, sectionView.bounds.size.width/2, sectionView.bounds.size.height)];
    invitationCtl.tag = InvitationTag;
    [invitationCtl addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:invitationCtl];
    invitationLabelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InvitationOff"] highlightedImage:[UIImage imageNamed:@"InvitationOn"]];
    [invitationLabelView setFrame:CGRectMake((sectionView.bounds.size.width/2-42)/2, (sectionView.bounds.size.height-14)/2, 42, 14)];
    [invitationLabelView setHighlighted:NO];
    [invitationCtl addSubview:invitationLabelView];
    
    //GreetingCard
    greetingCardCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, sectionView.bounds.size.width/2, sectionView.bounds.size.height)];
    greetingCardCtl.tag = GreetingCardTag;
    [greetingCardCtl addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:greetingCardCtl];
    greetingCardLabelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreetingCardOff"] highlightedImage:[UIImage imageNamed:@"GreetingCardOn"]];
    [greetingCardLabelView setFrame:CGRectMake((sectionView.bounds.size.width/2-28)/2, (sectionView.bounds.size.height-14)/2, 28, 14)];
    [greetingCardLabelView setHighlighted:YES];
    [greetingCardCtl addSubview:greetingCardLabelView];
    
    [self buildInvitationView];
    [self buildGreetingCardView];
    [self.view addSubview:invitationView];
    [self.view addSubview:greetingCardView];
}

- (void)changeSection:(UIControl *)section {
    if (section.tag == InvitationTag) {
        [self showInvitationView];
    } else if (section.tag == GreetingCardTag) {
        [self showGreetingCardView];
    }
}

- (void)showInvitationView {
    if (sectionFlag == InvitationTag) {
        return;
    }
//    invitationLabel.textColor = [ColorHandler colorWithHexString:@"#1de9B6"];
//    greetingCardLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    [invitationLabelView setHighlighted:YES];
    [greetingCardLabelView setHighlighted:NO];
    [sectionIndicator setFrame:CGRectMake((sectionView.bounds.size.width/2-90)/2+sectionView.bounds.size.width/2, 39, 90, 2)];
    [greetingCardView setFrame:CGRectMake(-1*self.view.bounds.size.width, 4+105, self.view.bounds.size.width, self.view.bounds.size.height-4)];
    [invitationView setFrame:CGRectMake(0, 4+105, self.view.bounds.size.width, self.view.bounds.size.height-4)];
    
    [sectionIndicator setTransform:CGAffineTransformMakeTranslation(-160,0)];
    [greetingCardView setTransform:CGAffineTransformMakeTranslation(320,0)];
    [invitationView setTransform:CGAffineTransformMakeTranslation(320, 0)];
    [UIView animateWithDuration:0.4f animations:^{
        [sectionIndicator setTransform:CGAffineTransformIdentity];
        [greetingCardView setTransform:CGAffineTransformIdentity];
        [invitationView setTransform:CGAffineTransformIdentity];
        sectionFlag = InvitationTag;
    }];
}

- (void)showGreetingCardView {
    if (sectionFlag == GreetingCardTag) {
        return;
    }
//    invitationLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
//    greetingCardLabel.textColor = [ColorHandler colorWithHexString:@"#1de9B6"];
    [invitationLabelView setHighlighted:NO];
    [greetingCardLabelView setHighlighted:YES];
    [sectionIndicator setFrame:CGRectMake((sectionView.bounds.size.width/2-90)/2, 39, 90, 2)];
    [greetingCardView setFrame:CGRectMake(0, 4+105, self.view.bounds.size.width, self.view.bounds.size.height-4)];
    [invitationView setFrame:CGRectMake(self.view.bounds.size.width, 4+105, self.view.bounds.size.width, self.view.bounds.size.height-4)];
    
    [sectionIndicator setTransform:CGAffineTransformMakeTranslation(160,0)];
    [greetingCardView setTransform:CGAffineTransformMakeTranslation(-320,0)];
    [invitationView setTransform:CGAffineTransformMakeTranslation(-320, 0)];
    
    [UIView animateWithDuration:0.4f animations:^{
        [sectionIndicator setTransform:CGAffineTransformIdentity];
        [greetingCardView setTransform:CGAffineTransformIdentity];
        [invitationView setTransform:CGAffineTransformIdentity];
        sectionFlag = GreetingCardTag;
    }];
}

- (void)buildInvitationView {
    //build template
    TemplateInfo *template_1 = [self buildTemplateWithID:@"36c7f4b4-dbe7-4886-9c87-f8ac6679a9ee" :@""  :[UIImage imageNamed:@"y001_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_2 = [self buildTemplateWithID:@"69639840-f7a3-4b96-97db-c4128ce6c358" :@"" :[UIImage imageNamed:@"y002_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_3 = [self buildTemplateWithID:@"68290803-d3ad-428e-9307-f8382be5cc83" :@"" :[UIImage imageNamed:@"y003_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_4 = [self buildTemplateWithID:@"c3c931ea-c690-43d1-ae28-9863bad7799b" :@"" :[UIImage imageNamed:@"y004_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_5 = [self buildTemplateWithID:@"544331a9-e6e5-41c1-9212-6fcf6f3b3ebc" :@"" :[UIImage imageNamed:@"x001_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_6 = [self buildTemplateWithID:@"9f42133f-929f-4998-9bbd-315effcb2c38" :@"" :[UIImage imageNamed:@"x002_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_7 = [self buildTemplateWithID:@"300a3507-751a-4fbf-8187-a82d1e68860c" :@"" :[UIImage imageNamed:@"x003_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_8 = [self buildTemplateWithID:@"22b7fd9f-74d7-44f2-87ef-5af810bed314" :@"" :[UIImage imageNamed:@"x004_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_9 = [self buildTemplateWithID:@"71bf36af-bb1e-42d5-a233-471ba7dbb54c" :@"" :[UIImage imageNamed:@"x005_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_10 = [self buildTemplateWithID:@"8d7c8889-d3c1-4384-9edd-5c9691c2e790" :@"" :[UIImage imageNamed:@"x006_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_11 = [self buildTemplateWithID:@"08d3b3f3-cef5-4c9f-bee9-29371dd180ba" :@"" :[UIImage imageNamed:@"x007_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_12 = [self buildTemplateWithID:@"68868dc2-a7ab-4866-b27e-a5679aee2e25" :@"" :[UIImage imageNamed:@"x008_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_13 = [self buildTemplateWithID:@"49e81bde-d51e-485d-be42-bbb269330081" :@"" :[UIImage imageNamed:@"x009_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_14 = [self buildTemplateWithID:@"fbbd474-2ecd-4054-add4-e994ddda128e" :@"" :[UIImage imageNamed:@"x010_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_15 = [self buildTemplateWithID:@"f127e1e0-0569-439c-ad03-2c980ed2f55a" :@"" :[UIImage imageNamed:@"x011_362_570.jpg"] :@"Invitation"];
    TemplateInfo *template_16 = [self buildTemplateWithID:@"27deb988-009b-431d-80cf-ba1349cef19c" :@"" :[UIImage imageNamed:@"x012_362_570.jpg"] :@"Invitation"];
    
    //build view
    invitationView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 4+105, self.view.bounds.size.width, self.view.bounds.size.height-4)];
    
    float contentViewHeight = 232;
    float contentViewWidth = invitationView.bounds.size.width-8;

    invitationView.contentSize = CGSizeMake(invitationView.bounds.size.width, 5*contentViewHeight);//TO BE RESIZE
    invitationView.showsHorizontalScrollIndicator = NO;
    invitationView.showsVerticalScrollIndicator = NO;
    
    
    
    //contentView 1
    HomeTemplateContentView *templateContentView_1 = [[HomeTemplateContentView alloc] initWithFrame:CGRectMake(4, 0, contentViewWidth, contentViewHeight)];
    templateContentView_1.backgroundPic = [UIImage imageNamed:@"h_category_1"];
    templateContentView_1.templateArray = [NSMutableArray arrayWithObjects:template_1,template_2,template_3,template_4, nil];
    //templateContentView_1.templateArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"y001_362_570.jpg"],[UIImage imageNamed:@"y002_362_570.jpg"],[UIImage imageNamed:@"y003_362_570.jpg"],[UIImage imageNamed:@"y004_362_570.jpg"], nil];
    templateContentView_1.delegate = self;
    [templateContentView_1 buildView];
    //[templateContentView_1 setUserInteractionEnabled:YES];
    //[templateContentView_1 addGestureRecognizer:tapGestureRecognizer];
    
    //contentView 2
    HomeTemplateContentView *templateContentView_2 = [[HomeTemplateContentView alloc] initWithFrame:CGRectMake(4, contentViewHeight + 4, contentViewWidth, contentViewHeight)];
    templateContentView_2.backgroundPic = [UIImage imageNamed:@"h_category_2"];
    templateContentView_2.templateArray = [NSMutableArray arrayWithObjects:template_5,template_6,template_7,template_8, nil];
    //templateContentView_2.templateArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"x001_362_570.jpg"],[UIImage imageNamed:@"x002_362_570.jpg"],[UIImage imageNamed:@"x003_362_570.jpg"],[UIImage imageNamed:@"x004_362_570.jpg"], nil];
    templateContentView_2.delegate = self;
    [templateContentView_2 buildView];

    //contentView 3
    HomeTemplateContentView *templateContentView_3 = [[HomeTemplateContentView alloc] initWithFrame:CGRectMake(4, 2*(contentViewHeight + 4), contentViewWidth, contentViewHeight)];
    templateContentView_3.backgroundPic = [UIImage imageNamed:@"h_category_3"];
    templateContentView_3.templateArray = [NSMutableArray arrayWithObjects:template_9,template_10,template_11,template_12, nil];
    //templateContentView_3.templateArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"x005_362_570.jpg"],[UIImage imageNamed:@"x006_362_570.jpg"],[UIImage imageNamed:@"x007_362_570.jpg"],[UIImage imageNamed:@"x008_362_570.jpg"], nil];
    templateContentView_3.delegate = self;
    [templateContentView_3 buildView];

    //contentView 4
    HomeTemplateContentView *templateContentView_4 = [[HomeTemplateContentView alloc] initWithFrame:CGRectMake(4, 3*(contentViewHeight + 4), contentViewWidth, contentViewHeight)];
    templateContentView_4.backgroundPic = [UIImage imageNamed:@"h_category_4"];
    templateContentView_4.templateArray = [NSMutableArray arrayWithObjects:template_13,template_14,template_15,template_16, nil];
    //templateContentView_4.templateArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"x009"],[UIImage imageNamed:@"x010"],[UIImage imageNamed:@"x011"],[UIImage imageNamed:@"x012"], nil];
    templateContentView_4.delegate = self;
    [templateContentView_4 buildView];
    
    
    
    [invitationView addSubview:templateContentView_1];
    [invitationView addSubview:templateContentView_2];
    [invitationView addSubview:templateContentView_3];
    [invitationView addSubview:templateContentView_4];
    
    [invitationView addGestureRecognizer:swipeGestureRight];
    
}

- (void)buildGreetingCardView {
    //build template
    TemplateInfo *template_1 = [self buildTemplateWithID:@"spring_festival_zoe_01" :@"spring_festival_zoe_01" :[UIImage imageNamed:@"spring_festival_zoe_01_362_570.jpg"] :@"GreetingCard_Spring"];
    TemplateInfo *template_2 = [self buildTemplateWithID:@"spring_festival_rey_01" :@"spring_festival_rey_01" :[UIImage imageNamed:@"spring_festival_rey_01_362_570.jpg"] :@"GreetingCard_Spring"];
    TemplateInfo *template_3 = [self buildTemplateWithID:@"spring_festival_hy_01" :@"spring_festival_hy_01" :[UIImage imageNamed:@"spring_festival_hy_01_362_570.jpg"] :@"GreetingCard_Spring"];
    TemplateInfo *template_4 = [self buildTemplateWithID:@"spring_festival_hy_02" :@"spring_festival_hy_02" :[UIImage imageNamed:@"spring_festival_hy_02_362_570.jpg"] :@"GreetingCard_Spring"];
    TemplateInfo *template_5 = [self buildTemplateWithID:@"valentine_day_zxy_01"  :@"valentine_day_zxy_01" :[UIImage imageNamed:@"valentine_day_zxy_01_362_570.jpg"] :@"GreetingCard_Valentine"];
    TemplateInfo *template_6 = [self buildTemplateWithID:@"valentine_day_zxy_02" :@"valentine_day_zxy_02" :[UIImage imageNamed:@"valentine_day_zxy_02_362_570.jpg"] :@"GreetingCard_Valentine"];
    TemplateInfo *template_7 = [self buildTemplateWithID:@"valentine_day_rey_01" :@"valentine_day_rey_01" :[UIImage imageNamed:@"valentine_day_rey_01_362_570.jpg"] :@"GreetingCard_Valentine"];
    TemplateInfo *template_8 = [self buildTemplateWithID:@"valentine_day_zoe_01" :@"valentine_day_zoe_01" :[UIImage imageNamed:@"valentine_day_zoe_01_362_570.jpg"] :@"GreetingCard_Valentine"];
    
    
    //build view
    greetingCardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 4+105, self.view.bounds.size.width, self.view.bounds.size.height-4)];
    
    float contentViewHeight = 232;
    float contentViewWidth = greetingCardView.bounds.size.width-8;
    
    greetingCardView.contentSize = CGSizeMake(greetingCardView.bounds.size.width, 3*contentViewHeight);//TO BE RESIZE
    greetingCardView.showsHorizontalScrollIndicator = NO;
    greetingCardView.showsVerticalScrollIndicator = NO;
    
    
    //contentView 1
    HomeTemplateContentView *templateContentView_1 = [[HomeTemplateContentView alloc] initWithFrame:CGRectMake(4, 0, contentViewWidth, contentViewHeight)];
    templateContentView_1.backgroundPic = [UIImage imageNamed:@"event_1"];
    templateContentView_1.templateArray = [NSMutableArray arrayWithObjects:template_1,template_2,template_3,template_4, nil];
    //templateContentView_1.templateArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"Christmas_1_362_570.jpg"],[UIImage imageNamed:@"Christmas_2_362_570.jpg"],[UIImage imageNamed:@"Christmas_3_362_570.jpg"],[UIImage imageNamed:@"Christmas_4_362_570.jpg"], nil];
    templateContentView_1.delegate = self;
    [templateContentView_1 buildView];
    
    //contentView 2
    HomeTemplateContentView *templateContentView_2 = [[HomeTemplateContentView alloc] initWithFrame:CGRectMake(4, contentViewHeight + 4, contentViewWidth, contentViewHeight)];
    templateContentView_2.backgroundPic = [UIImage imageNamed:@"event_2"];
    templateContentView_2.templateArray = [NSMutableArray arrayWithObjects:template_5,template_6,template_7,template_8, nil];
    //templateContentView_2.templateArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"NewYearDay_1_362_570.jpg"],[UIImage imageNamed:@"NewYearDay_2_362_570.jpg"],[UIImage imageNamed:@"NewYearDay_3_362_570.jpg"],[UIImage imageNamed:@"NewYearDay_4_362_570.jpg"], nil];
    templateContentView_2.delegate = self;
    [templateContentView_2 buildView];
    
    [greetingCardView addSubview:templateContentView_1];
    [greetingCardView addSubview:templateContentView_2];
    
    [greetingCardView addGestureRecognizer:swipeGestureLeft];
}

- (TemplateInfo *)buildTemplateWithID:(NSString *)ID :(NSString *)name :(UIImage *)image :(NSString *)category {
    TemplateInfo *template = [TemplateInfo new];
    template.ID = ID;
    template.name = name;
    template.thumbnail = UIImagePNGRepresentation(image);
    template.category = category;
    return template;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseTemplate:(TemplateInfo *)template {
    [self.delegate didChooseTemplate:template];
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
