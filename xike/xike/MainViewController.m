//
//  MainViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-27.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "MainViewController.h"
#import "ColorHandler.h"
#import "TabbarView.h"
#import "ExploreViewController.h"
#import "CreateNewEventViewController.h"
#import "MyEventsViewController.h"
#import "TemplateDisplayViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *leftSideView;

@end

@implementation MainViewController {
    UIView *contentView;
    TabbarView *tabbarView;
    SettingViewController *settingViewController;
    ExploreViewController *exploreViewController;
    TemplateDisplayViewController *templateDisplayViewController;
    MyEventsViewController *myEventsViewController;
    CreateNewEventViewController *createNewEventViewController;
    UIViewController *currentViewController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UITapGestureRecognizer *tapClickEventRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    CGFloat currentTranslate;
    BOOL sideBarShowing;
    NSInteger g_flags;
}
const int offset=155;
const int minOffset=60;
const float MoveAnimationDuration = 0.3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    //[self viewDidLoad];
    //TabBar
    tabbarView = [[TabbarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49) withSelectedTag:g_flags];
    tabbarView.delegate = self;
    [self.mainView addSubview:tabbarView];
    //Add gesture
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInMainView:)];
    //[self.mainView addGestureRecognizer:_panGestureReconginzer];
    [contentView addGestureRecognizer:_panGestureReconginzer];
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sideBarShowing = NO;
    currentTranslate = 0;
    _database = [XikeDatabase new];
    if (!_user) {
        _user = [_database getUserInfo];
    }
    g_flags = 3;
    //NavaigationBar
    [self.navigationItem setTitle:@"个人主页"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBar.translucent = NO;
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(popSettingView)];
    settingButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:settingButtonItem];

    //SettingView
    self.leftSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    settingViewController = [[SettingViewController alloc] init];
    settingViewController.delegate = self;
    settingViewController.database = _database;
    settingViewController.user = _user;

    //mainView
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.mainView.layer.shadowOffset = CGSizeMake(0, 0);
    self.mainView.layer.shadowColor = [ColorHandler colorWithHexString:@"#413445"].CGColor;
    self.mainView.layer.shadowOpacity = 1;
    
    [self buildMainView];
    [self.view addSubview:self.mainView];
    
    
}


- (void)mainViewAddTapGestures {
    if (_tapGestureRecognizer) {
        [self.mainView removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMainView:)];
    [self.mainView addGestureRecognizer:_tapGestureRecognizer];
}


- (void)buildMainView {
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    //TabBar
    //tabbarView = [[TabbarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    //tabbarView.delegate = self;
    
    myEventsViewController = [MyEventsViewController new];
    myEventsViewController.database = _database;
    myEventsViewController.user = _user;
    [self addChildViewController:myEventsViewController];
    
    //exploreViewController = [ExploreViewController new];
    //[self addChildViewController:exploreViewController];
    
    templateDisplayViewController = [TemplateDisplayViewController new];
    templateDisplayViewController.database = _database;
    templateDisplayViewController.user = _user;
    [self addChildViewController:templateDisplayViewController];
    
    
    [contentView addSubview:myEventsViewController.view];
    currentViewController = myEventsViewController;
    
    [self.mainView addSubview:contentView];
    //[self.mainView addSubview:tabbarView];
}
- (void)popSettingView {
    if (!sideBarShowing) {
        [self addChildViewController:settingViewController];
        settingViewController.view.frame = self.view.bounds;
        [self.leftSideView addSubview:settingViewController.view];
        [self.view insertSubview:self.leftSideView belowSubview:self.mainView];
        [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
        [self.navigationItem setTitle:@"设置"];
    } else {
        [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma TabbarViewDelegate

-(void)FirstBtnClick{
    
    if(g_flags==1)
        return;
    /*
    [self transitionFromViewController:currentViewController toViewController:exploreViewController duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        currentViewController=exploreViewController;
        g_flags=1;
        [self.navigationItem setTitle:@"发现"];
        
    }];
     */
    [self transitionFromViewController:currentViewController toViewController:templateDisplayViewController duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        currentViewController=templateDisplayViewController;
        g_flags=1;
        [self.navigationItem setTitle:@"模板"];
        
    }];
    [tabbarView buttonClickAction:tabbarView.firstBtn];
}
-(void)SecondBtnClick{
    createNewEventViewController = [CreateNewEventViewController new];
    createNewEventViewController.database = _database;
    createNewEventViewController.user = _user;
    createNewEventViewController.isCreate = YES;
    [self.navigationController pushViewController:createNewEventViewController animated:YES];
}
-(void)ThirdBtnClick{
    if(g_flags==3){
        return;
    }
    
    [self transitionFromViewController:currentViewController toViewController:myEventsViewController duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        currentViewController=myEventsViewController;
        g_flags=3;
        [self.navigationItem setTitle:@"个人主页"];
    }];
    
    [tabbarView buttonClickAction:tabbarView.thirdBtn];
}


#pragma gestureMethod
- (void)tapOnMainView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)panInMainView:(UIPanGestureRecognizer *)panGestureReconginzer {
    if (panGestureReconginzer.state == UIGestureRecognizerStateChanged) {
        CGFloat translation = [panGestureReconginzer translationInView:self.mainView].x;
        if (translation > 0) {
            self.mainView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
            UIView *view;
            if (translation + currentTranslate > 0) {
                view = settingViewController.view;
            }
            
            [self addChildViewController:settingViewController];
            settingViewController.view.frame = self.view.bounds;
            [self.leftSideView addSubview:view];
            [self.view insertSubview:self.leftSideView belowSubview:self.mainView];
            [self.leftSideView bringSubviewToFront:view];
        } else {
            if (sideBarShowing) {
                if (translation+currentTranslate >=0) {
                    self.mainView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
                }
            } else {
                NSLog(@"111");
                [contentView removeGestureRecognizer:panGestureReconginzer];
            }
        }
        
    } else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded) {
        currentTranslate = self.mainView.transform.tx;
        if (!sideBarShowing) {
            if ((currentTranslate) < minOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            } else if (currentTranslate > minOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        } else {
            if (fabs(currentTranslate)<offset-minOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            } else if (currentTranslate>offset-minOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                
            }
        }
    }
}


#pragma animation
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.mainView.transform  = CGAffineTransformMakeTranslation(0, 0);
                if (g_flags == 1) {
                    [self.navigationItem setTitle:@"模板"];
                } else {
                    [self.navigationItem setTitle:@"个人主页"];
                }
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.mainView.transform  = CGAffineTransformMakeTranslation(offset, 0);
                [self.navigationItem setTitle:@"设置"];
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.mainView.userInteractionEnabled = YES;
        self.leftSideView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.mainView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            
        }else
        {
            [self mainViewAddTapGestures];
            sideBarShowing = YES;
        }
        currentTranslate = self.mainView.transform.tx;
	};
    self.mainView.userInteractionEnabled = NO;
    self.leftSideView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

#pragma SettingViewControllerDelegate
- (void)pushViewController:(UIViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)changeUserInfo:(UserInfo *)user {
    myEventsViewController.pictureView.image = [UIImage imageWithData:user.photo];
    myEventsViewController.nicknameLabel.text = user.name;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
