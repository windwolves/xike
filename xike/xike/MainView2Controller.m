//
//  MainView2Controller.m
//  xike
//
//  Created by Leading Chen on 14/12/1.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "MainView2Controller.h"
#import "ColorHandler.h"
#import "NotificationViewController.h"
#import "HomePageViewController.h"
#import "MyEventsViewController.h"
#import "MyBoxViewController.h"
#import "CreateNewEventViewController.h"
#import "NotificationViewController.h"
#import "UIImage+Blur.h"
#import "ChooseTemplateView2Controller.h"
#import "CreateInvitationViewController.h"
#import "CreateGreetingCardViewController.h"

@interface MainView2Controller ()

@end

@implementation MainView2Controller {
    UIBarButtonItem *notificationButtonItem;
    SettingView2Controller *settingViewController;
    HomePageViewController *homepageViewController;
    MyEventsViewController *myEventsViewController;
    MyBoxViewController *myBoxViewController;
    CreateNewEventViewController *createNewEventViewController;
    NotificationViewController *notificationViewController;
    UIViewController *currentViewController;
    TabbarView *tabbarView;
    UIView *mainView;
    UIView *maskView;
    UIView *tipsMaskView;
    UIView *createView;
    UIImageView *templateImageView;
    UIImageView *tipsForNewStuff_1;
    UIImageView *tipsForNewStuff_2;
    UIImageView *tipsForNewStuff_3;
    UIButton *createInvitationButton;
    UIButton *createGreetingCardButton;
    UITapGestureRecognizer *tapGesture;
    UITapGestureRecognizer *tapGestureRecognizer;
    UITapGestureRecognizer *tapGesture2;
    NSInteger g_flags;
    NSInteger tipsNum;
    TemplateInfo *templateToCreate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initilize
    _database = [XikeDatabase new];
    if (!_user) {
        _user = [_database getUserInfo];
    }
    g_flags = 1;
    
    
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    /*
    [self.navigationItem setTitle:@"稀客"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    
    notificationButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notification_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popNotificationView)];
    [self.navigationItem setRightBarButtonItem:notificationButtonItem];
    */
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMaskView)];
    tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCreateView)];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTips)];
    
    //HomePage
    homepageViewController = [HomePageViewController new];
    homepageViewController.database = _database;
    homepageViewController.user = _user;
    homepageViewController.delegate = self;
    [self addChildViewController:homepageViewController];
    
    //EventsView
    myEventsViewController = [MyEventsViewController new];
    myEventsViewController.database = _database;
    myEventsViewController.user = _user;
    //[self addChildViewController:myEventsViewController];
    
    //BoxView
    myBoxViewController = [MyBoxViewController new];
    myBoxViewController.database = _database;
    myBoxViewController.user = _user;
    [self addChildViewController:myBoxViewController];
    
    //MainView
    //mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    currentViewController = homepageViewController;
    [self.view addSubview:currentViewController.view];
    
    //Mask View
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    maskView.backgroundColor = [ColorHandler colorWithHexString:@"#000000"];
    maskView.alpha = 0.8f;
    
    //Create Button
    createInvitationButton = [[UIButton alloc] initWithFrame:CGRectMake(52, self.view.bounds.size.height, 71, 96)];
    [createInvitationButton setImage:[UIImage imageNamed:@"create_invitation"] forState:UIControlStateNormal];
    [createInvitationButton addTarget:self action:@selector(createInvitation) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:createInvitationButton];
    
    createGreetingCardButton = [[UIButton alloc] initWithFrame:CGRectMake(196, self.view.bounds.size.height, 71, 96)];
    [createGreetingCardButton setImage:[UIImage imageNamed:@"create_greeting_card"] forState:UIControlStateNormal];
    [createGreetingCardButton addTarget:self action:@selector(createGreetingCard) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:createGreetingCardButton];
    
    //Tabbar View
    [self buildTabbarView];
}


- (void)viewWillAppear:(BOOL)animated {
    //Remove maskView
    [maskView removeFromSuperview];
    [maskView removeGestureRecognizer:tapGesture];
    [createInvitationButton removeFromSuperview];
    [createGreetingCardButton removeFromSuperview];
    [createView removeFromSuperview];
    [self buildTabbarView];
    //Tips
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tipsForNewStuff"]) {
        [self buildTipsForNewStuff];
    }
}

- (void)buildTabbarView {
    //TabBar
    tabbarView = [[TabbarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-48, self.view.bounds.size.width, 48) withSelectedTag:g_flags];
    tabbarView.delegate = self;
    tabbarView.layer.contents = (id)[self getBlurImageWithCGRect:tabbarView.frame].CGImage;
    [self.view addSubview:tabbarView];
    [self.view bringSubviewToFront:tabbarView];
}

- (void)buildTipsForNewStuff {
    tipsNum = 0;
    tipsMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    tipsMaskView.backgroundColor = [ColorHandler colorWithHexString:@"#000000"];
    tipsMaskView.alpha = 0.8f;
    [tipsMaskView addGestureRecognizer:tapGestureRecognizer];
    tipsForNewStuff_1 = [[UIImageView alloc] initWithFrame:CGRectMake(112, 70, 195, 90)];
    tipsForNewStuff_1.image = [UIImage imageNamed:@"TipsForNewStuff_1"];
    tipsForNewStuff_2 = [[UIImageView alloc] initWithFrame:CGRectMake(80, 225, 195, 173)];
    tipsForNewStuff_2.image = [UIImage imageNamed:@"TipsForNewStuff_2"];
    tipsForNewStuff_3 = [[UIImageView alloc] initWithFrame:CGRectMake(8, maskView.bounds.size.height-122, 212, 120)];
    tipsForNewStuff_3.image = [UIImage imageNamed:@"TipsForNewStuff_3"];
    
    [tipsMaskView addSubview:tipsForNewStuff_1];
    [self.view addSubview:tipsMaskView];
}

- (void)nextTips {
    if (tipsNum == 0) {
        [tipsForNewStuff_1 removeFromSuperview];
        [tipsMaskView addSubview:tipsForNewStuff_2];
        
    }
    if (tipsNum == 1) {
        [tipsForNewStuff_2 removeFromSuperview];
        [tipsMaskView addSubview:tipsForNewStuff_3];
    }
    if (tipsNum == 2) {
        [tipsForNewStuff_3 removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tipsForNewStuff"];
        [tipsMaskView removeGestureRecognizer:tapGestureRecognizer];
        [tipsMaskView removeFromSuperview];
        
    }
    tipsNum ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popSettingView {
    settingViewController = [[SettingView2Controller alloc] init];
    settingViewController.delegate = self;
    settingViewController.database = _database;
    settingViewController.user = _user;
    
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

#pragma TabbarViewDelegate
-(void)FirstBtnClick{
    
    if(g_flags==1) {
        return;
    }
    [self transitionFromViewController:currentViewController toViewController:homepageViewController duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        currentViewController=homepageViewController;
        //[tabbarView removeFromSuperview];
        //tabbarView.layer.contents = (id)[self getBlurImageWithCGRect:tabbarView.frame].CGImage;
        //[self.view addSubview:tabbarView];
                [self.view bringSubviewToFront:tabbarView];
        g_flags=1;
    }];
    [tabbarView buttonClickAction:tabbarView.firstBtn];
}

-(void)SecondBtnClick{
    
    [self createButtonAnimation:@"UP"];
    
}

-(void)ThirdBtnClick{
    if(g_flags==3){
        return;
    }
    [self transitionFromViewController:currentViewController toViewController:myBoxViewController duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        currentViewController=myBoxViewController;
        //[tabbarView removeFromSuperview];
        //tabbarView.layer.contents = (id)[self getBlurImageWithCGRect:tabbarView.frame].CGImage;
        [self.view bringSubviewToFront:tabbarView];
        //[self.view addSubview:tabbarView];
        g_flags=3;
    }];
    [tabbarView buttonClickAction:tabbarView.thirdBtn];
}

- (void)createButtonAnimation:(NSString *)direction {
    if ([direction isEqualToString:@"UP"]) {
        [createGreetingCardButton setFrame:CGRectMake(196, 259, 71, 96)];
        [createInvitationButton setFrame:CGRectMake(52, 259, 71, 96)];
        [createGreetingCardButton setTransform:CGAffineTransformMakeTranslation(0,259)];
        [createInvitationButton setTransform:CGAffineTransformMakeTranslation(0,259)];
        [UIView animateWithDuration:0.6f animations:^{
            [createGreetingCardButton setTransform:CGAffineTransformIdentity];
            [createInvitationButton setTransform:CGAffineTransformIdentity];
            [self.view addSubview:maskView];
            [maskView addGestureRecognizer:tapGesture];
            [createInvitationButton removeFromSuperview];
            [createGreetingCardButton removeFromSuperview];
            [self.view addSubview:createInvitationButton];
            [self.view addSubview:createGreetingCardButton];
        }];
        
    } else if([direction isEqualToString:@"DOWN"]) {
        [createGreetingCardButton setFrame:CGRectMake(196, self.view.bounds.size.height, 71, 96)];
        [createInvitationButton setFrame:CGRectMake(52, self.view.bounds.size.height, 71, 96)];
        [createGreetingCardButton setTransform:CGAffineTransformMakeTranslation(0,-259)];
        [createInvitationButton setTransform:CGAffineTransformMakeTranslation(0,-259)];
        [UIView animateWithDuration:0.6f animations:^{
            [createGreetingCardButton setTransform:CGAffineTransformIdentity];
            [createInvitationButton setTransform:CGAffineTransformIdentity];
            [maskView removeGestureRecognizer:tapGesture];
        } completion:^(BOOL finished){
            [maskView removeFromSuperview];
            [self buildTabbarView];
        }];
    }
}

- (void)removeMaskView {
    [self createButtonAnimation:@"DOWN"];
}

- (void)createInvitation {
    ChooseTemplateView2Controller *chooseTemplateViewController = [ChooseTemplateView2Controller new];
    chooseTemplateViewController.createItem = @"Invitation";
    chooseTemplateViewController.user = _user;
    chooseTemplateViewController.database = _database;
    [self.navigationController pushViewController:chooseTemplateViewController animated:YES];
}

- (void)createGreetingCard {
    ChooseTemplateView2Controller *chooseTemplateViewController = [ChooseTemplateView2Controller new];
    chooseTemplateViewController.createItem = @"GreetingCard";
    chooseTemplateViewController.user = _user;
    chooseTemplateViewController.database = _database;
    [self.navigationController pushViewController:chooseTemplateViewController animated:YES];
}


- (void)buildCreateView {
    createView = [[UIView alloc] initWithFrame:CGRectMake(31, 116+self.view.bounds.size.height, 257, 380)];
    createView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    templateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(39, 34, 181, 285)];
    [templateImageView setImage:[UIImage imageWithData:templateToCreate.thumbnail]];
    UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 340, createView.bounds.size.width, 40)];
    createButton.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    [createButton setTitle:@"创建" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createItem) forControlEvents:UIControlEventTouchUpInside];
    UIControl *cancelCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [cancelCtl addTarget:self action:@selector(dismissCreateView) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *cancelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 14, 14)];
    [cancelImageView setImage:[UIImage imageNamed:@"cancel_cross"]];
    [cancelCtl addSubview:cancelImageView];
    
    [createView addSubview:cancelCtl];
    [createView addSubview:templateImageView];
    [createView addSubview:createButton];
    
}

- (void)dismissCreateView {
    [maskView removeGestureRecognizer:tapGesture2];
    [createView setFrame:CGRectMake(31, self.view.bounds.size.height, 257, 380)];
    [createView setTransform:CGAffineTransformMakeTranslation(0, -(self.view.bounds.size.height-116))];
    [UIView animateWithDuration:0.6f animations:^{
        [createView setTransform:CGAffineTransformIdentity];
        [maskView removeFromSuperview];
    }];
}

- (void)createItem {
    if ([templateToCreate.category isEqualToString:@"Invitation"]) {
        CreateInvitationViewController *createInvitationViewController = [CreateInvitationViewController new];
        createInvitationViewController.database = _database;
        createInvitationViewController.user = _user;
        createInvitationViewController.template = templateToCreate;
        createInvitationViewController.isCreate = YES;
        
        [self.navigationController pushViewController:createInvitationViewController animated:YES];
    } else if ([templateToCreate.category isEqualToString:@"GreetingCard_Valentine"]) {
        CreateGreetingCardViewController *createGreetingCardController = [CreateGreetingCardViewController new];
        createGreetingCardController.database = _database;
        createGreetingCardController.user = _user;
        createGreetingCardController.template = templateToCreate;
        createGreetingCardController.theme = @"Valentine";
        createGreetingCardController.isCreate = YES;
        [self.navigationController pushViewController:createGreetingCardController animated:YES];
    } else if ([templateToCreate.category isEqualToString:@"GreetingCard_Spring"]) {
        CreateGreetingCardViewController *createGreetingCardController = [CreateGreetingCardViewController new];
        createGreetingCardController.database = _database;
        createGreetingCardController.user = _user;
        createGreetingCardController.template = templateToCreate;
        createGreetingCardController.theme = @"Spring";
        createGreetingCardController.isCreate = YES;
        [self.navigationController pushViewController:createGreetingCardController animated:YES];
    }
}

#pragma HomePageViewDelegate
- (void)didChangeSection {
    //when section is changed, the tab bar should be re-render
    tabbarView.layer.contents = (id)[self getBlurImageWithCGRect:tabbarView.frame].CGImage;
}

- (void)popNotificationView {
    notificationViewController = [NotificationViewController new];
    notificationViewController.database = _database;
    notificationViewController.user = _user;
    
    [self.navigationController pushViewController:notificationViewController animated:YES];
}

- (void)didChooseTemplate:(TemplateInfo *)template {
    templateToCreate = template;
    [self buildCreateView];
    [maskView addGestureRecognizer:tapGesture2];
    [createView setFrame:CGRectMake(31, 116, 257, 380)];
    [createView setTransform:CGAffineTransformMakeTranslation(0, self.view.bounds.size.height-116)];
    [UIView animateWithDuration:0.6f animations:^{
        [createView setTransform:CGAffineTransformIdentity];
        [createView removeFromSuperview];
        [self.view addSubview:maskView];
        [self.view addSubview:createView];
    }];
    
}

- (UIImage *)getBlurImageWithCGRect:(CGRect)rect {
    //Render the layer in the image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CALayer *layer = self.view.layer;
    [layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    image = [[UIImage imageWithData:imageData] drn_boxblurImageWithBlur:0.3f];
    
    return image;
}

#pragma SettingView2ControllerDelegate
- (void)didFinishAccountSettingwith:(UserInfo *)user {
    myEventsViewController.pictureView.image = [UIImage imageWithData:user.photo];
    myEventsViewController.nicknameLabel.text = user.name;
}

@end
