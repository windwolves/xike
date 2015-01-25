//
//  AppDelegate.m
//  xike
//
//  Created by Leading Chen on 14-8-22.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "AppDelegate.h"
#import "XikeDatabase.h"
#import "UserLogonViewController.h"
#import "MainViewController.h"
#import "UserInfoViewController.h"
#import "GuideViewController.h"
#import "ShareEngine.h"
#import "Contants.h"
#import "MainView2Controller.h"

@implementation AppDelegate {
    GuideViewController *guideViewController;
    UserLogonViewController *logonViewController;
    MainViewController *mainViewController;
    MainView2Controller *mainView2Controller;
    NSString *token;
    XikeDatabase *database;
    UserInfo *user;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigation;
    
    [[ShareEngine sharedInstance] registerApp];
    //NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);

    database = [[XikeDatabase alloc] init];
    user = [UserInfo new];
    
    if (launchOptions) {
        //TODO
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleNotification:userInfo];
    }

    //Register APN service
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   // [defaults setFloat:1.0 forKey:@"version"];// Set Version
    if (![defaults boolForKey:@"everLaunched"]) { //check whether first launch or not
        //if it's the first time, then create all tables and set defaults.
        if ([database createAllTables]) {
            [defaults setBool:YES forKey:@"everLaunched"];
            [defaults setBool:YES forKey:@"tipsForNewStuff"];
            [self setUpBasicTemplate];
            
            logonViewController = [UserLogonViewController new];
            logonViewController.database = database;
            logonViewController.deviceToken = token;
            
            guideViewController = [GuideViewController new];
            guideViewController.logonViewController = logonViewController;
            guideViewController.destination = Destination_logon;
            
            //navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
            self.window.rootViewController = guideViewController;
            
        } else {
            NSLog(@"Tables cannot be created!");
            return NO;
        }
    } else {
        //if it's not the first time, then direct to the main view.
        if ([defaults floatForKey:@"version"] != app_version) {
            [database createAllTables];
            [self setUpBasicTemplate];
            [defaults setBool:YES forKey:@"tipsForNewStuff"];
            if (![defaults boolForKey:@"isLogin"]) {
                logonViewController = [UserLogonViewController new];
                logonViewController.database = database;
                logonViewController.deviceToken = token;
                guideViewController = [GuideViewController new];
                guideViewController.logonViewController = logonViewController;
                guideViewController.destination = Destination_logon;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:guideViewController];
                self.window.rootViewController = navigation;
            } else {
                [database createAllTables];
                [self setUpBasicTemplate];
                user = [database getUserInfo];
                
                mainView2Controller = [MainView2Controller new];
                mainView2Controller.database = database;
                mainView2Controller.user = user;
                
                guideViewController = [GuideViewController new];
                guideViewController.mainView2Controller = mainView2Controller;
                guideViewController.destination = Destination_main;
                navigation = [[UINavigationController alloc] initWithRootViewController:guideViewController];
            }
        } else {
            if (![defaults boolForKey:@"isLogin"]) {
                logonViewController = [UserLogonViewController new];
                logonViewController.database = database;
                logonViewController.deviceToken = token;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
                self.window.rootViewController = navigation;
            } else {
                user = [database getUserInfo];
                
                mainView2Controller = [MainView2Controller new];
                mainView2Controller.database = database;
                mainView2Controller.user = user;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:mainView2Controller];
                
            }
        }
        self.window.rootViewController = navigation;
    }
    
    [self.window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:0.4];
    return YES;
}

- (void)setUpBasicTemplate {
    //delete all templates at first!
    if ([database deleteAllTemplaes]) {
        NSMutableArray *basicTemplates = [self prepareTempaltes];
        for (TemplateInfo *template in basicTemplates) {
            [database insertTemplate:template];
        }
    }
}

- (NSMutableArray *)prepareTempaltes {
    //v1.0
    //x001
    NSMutableArray *basicTemplates = [NSMutableArray new];
    TemplateInfo *template_001 = [TemplateInfo new];
    template_001.ID = @"544331a9-e6e5-41c1-9212-6fcf6f3b3ebc";
    template_001.name = @"x001";
    template_001.desc = @"";
    template_001.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x001_362_570.jpg"]);
    template_001.category = @"Invitation";
    template_001.recommendation = 10;
    [basicTemplates addObject:template_001];
    //x002
    TemplateInfo *template_002 = [TemplateInfo new];
    template_002.ID = @"9f42133f-929f-4998-9bbd-315effcb2c38";
    template_002.name = @"x002";
    template_002.desc = @"";
    template_002.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x002_362_570.jpg"]);
    template_002.category = @"Invitation";
    template_002.recommendation = 10;
    [basicTemplates addObject:template_002];
    //x003
    TemplateInfo *template_003 = [TemplateInfo new];
    template_003.ID = @"300a3507-751a-4fbf-8187-a82d1e68860c";
    template_003.name = @"x003";
    template_003.desc = @"";
    template_003.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x003_362_570.jpg"]);
    template_003.category = @"Invitation";
    template_003.recommendation = 10;
    [basicTemplates addObject:template_003];
    //x004
    TemplateInfo *template_004 = [TemplateInfo new];
    template_004.ID = @"22b7fd9f-74d7-44f2-87ef-5af810bed314";
    template_004.name = @"x004";
    template_004.desc = @"";
    template_004.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x004_362_570.jpg"]);
    template_004.category = @"Invitation";
    template_004.recommendation = 10;
    [basicTemplates addObject:template_004];
    //x005
    TemplateInfo *template_005 = [TemplateInfo new];
    template_005.ID = @"71bf36af-bb1e-42d5-a233-471ba7dbb54c";
    template_005.name = @"x005";
    template_005.desc = @"";
    template_005.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x005_362_570.jpg"]);
    template_005.category = @"Invitation";
    template_005.recommendation = 10;
    [basicTemplates addObject:template_005];
    //x006
    TemplateInfo *template_006 = [TemplateInfo new];
    template_006.ID = @"8d7c8889-d3c1-4384-9edd-5c9691c2e790";
    template_006.name = @"x006";
    template_006.desc = @"";
    template_006.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x006_362_570.jpg"]);
    template_006.category = @"Invitation";
    template_006.recommendation = 10;
    [basicTemplates addObject:template_006];
    //x007
    TemplateInfo *template_007 = [TemplateInfo new];
    template_007.ID = @"08d3b3f3-cef5-4c9f-bee9-29371dd180ba";
    template_007.name = @"x007";
    template_007.desc = @"";
    template_007.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x007_362_570.jpg"]);
    template_007.category = @"Invitation";
    template_007.recommendation = 10;
    [basicTemplates addObject:template_007];
    //x008
    TemplateInfo *template_008 = [TemplateInfo new];
    template_008.ID = @"68868dc2-a7ab-4866-b27e-a5679aee2e25";
    template_008.name = @"x008";
    template_008.desc = @"";
    template_008.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x008_362_570.jpg"]);
    template_008.category = @"Invitation";
    template_008.recommendation = 10;
    [basicTemplates addObject:template_008];
    //x009
    TemplateInfo *template_009 = [TemplateInfo new];
    template_009.ID = @"49e81bde-d51e-485d-be42-bbb269330081";
    template_009.name = @"x009";
    template_009.desc = @"";
    template_009.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x009_362_570.jpg"]);
    template_009.category = @"Invitation";
    template_009.recommendation = 10;
    [basicTemplates addObject:template_009];
    //x010
    TemplateInfo *template_010 = [TemplateInfo new];
    template_010.ID = @"5fbbd474-2ecd-4054-add4-e994ddda128e";
    template_010.name = @"x010";
    template_010.desc = @"";
    template_010.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x010_362_570.jpg"]);
    template_010.category = @"Invitation";
    template_010.recommendation = 10;
    [basicTemplates addObject:template_010];
    //x011
    TemplateInfo *template_011 = [TemplateInfo new];
    template_011.ID = @"f127e1e0-0569-439c-ad03-2c980ed2f55a";
    template_011.name = @"x011";
    template_011.desc = @"";
    template_011.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x011_362_570.jpg"]);
    template_011.category = @"Invitation";
    template_011.recommendation = 10;
    [basicTemplates addObject:template_011];
    //x012
    TemplateInfo *template_012 = [TemplateInfo new];
    template_012.ID = @"27deb988-009b-431d-80cf-ba1349cef19c";
    template_012.name = @"x012";
    template_012.desc = @"";
    template_012.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"x012_362_570.jpg"]);
    template_012.category = @"Invitation";
    template_012.recommendation = 10;
    [basicTemplates addObject:template_012];
    //update on 2014-11-14
    //v1.10
    //y001
    TemplateInfo *template_y001 = [TemplateInfo new];
    template_y001.ID = @"36c7f4b4-dbe7-4886-9c87-f8ac6679a9ee";
    template_y001.name = @"y001";
    template_y001.desc = @"";
    template_y001.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"y001_362_570.jpg"]);
    template_y001.category = @"Invitation";
    template_y001.recommendation = 8.8;
    [basicTemplates addObject:template_y001];
    //y002
    TemplateInfo *template_y002 = [TemplateInfo new];
    template_y002.ID = @"69639840-f7a3-4b96-97db-c4128ce6c358";
    template_y002.name = @"y002";
    template_y002.desc = @"";
    template_y002.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"y002_362_570.jpg"]);
    template_y002.category = @"Invitation";
    template_y002.recommendation = 8.7;
    [basicTemplates addObject:template_y002];
    //y003
    TemplateInfo *template_y003 = [TemplateInfo new];
    template_y003.ID = @"68290803-d3ad-428e-9307-f8382be5cc83";
    template_y003.name = @"y003";
    template_y003.desc = @"";
    template_y003.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"y003_362_570.jpg"]);
    template_y003.category = @"Invitation";
    template_y003.recommendation = 8.6;
    [basicTemplates addObject:template_y003];
    //y004
    TemplateInfo *template_y004 = [TemplateInfo new];
    template_y004.ID = @"c3c931ea-c690-43d1-ae28-9863bad7799b";
    template_y004.name = @"y004";
    template_y004.desc = @"";
    template_y004.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"y004_362_570.jpg"]);
    template_y004.category = @"Invitation";
    template_y004.recommendation = 8.5;
    [basicTemplates addObject:template_y004];
    
    //Update on 2014-12-11
    //v 1.11
    //christmas 1
    TemplateInfo *template_christmas_1 = [TemplateInfo new];
    template_christmas_1.ID = @"7095bc04-0949-4985-801e-e9340c9e756c";
    template_christmas_1.name = @"Christmas_1";
    template_christmas_1.desc = @"Card_hy_Christmas_1";
    template_christmas_1.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"Christmas_1_362_570.jpg"]);
    template_christmas_1.category = @"GreetingCard_Christmas";
    template_christmas_1.recommendation = 8.5;
    [basicTemplates addObject:template_christmas_1];
    //christmas 2
    TemplateInfo *template_christmas_2 = [TemplateInfo new];
    template_christmas_2.ID = @"9adabeb9-9405-4d9e-91ce-a5608c79934a";
    template_christmas_2.name = @"Christmas_2";
    template_christmas_2.desc = @"Card_hy_Christmas_2";
    template_christmas_2.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"Christmas_2_362_570.jpg"]);
    template_christmas_2.category = @"GreetingCard_Christmas";
    template_christmas_2.recommendation = 8.5;
    [basicTemplates addObject:template_christmas_2];
    //christmas 3
    TemplateInfo *template_christmas_3 = [TemplateInfo new];
    template_christmas_3.ID = @"61e744e8-430b-4d7a-841b-d34caaf49a36";
    template_christmas_3.name = @"Christmas_3";
    template_christmas_3.desc = @"tem_rey_Christmasx1";
    template_christmas_3.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"Christmas_3_362_570.jpg"]);
    template_christmas_3.category = @"GreetingCard_Christmas";
    template_christmas_3.recommendation = 8.5;
    [basicTemplates addObject:template_christmas_3];
    //christmas 1
    TemplateInfo *template_christmas_4 = [TemplateInfo new];
    template_christmas_4.ID = @"cb99c1f7-3dc4-4848-b080-296ed0a4c254";
    template_christmas_4.name = @"Christmas_4";
    template_christmas_4.desc = @"tem_rey_Christmasx2";
    template_christmas_4.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"Christmas_4_362_570.jpg"]);
    template_christmas_4.category = @"GreetingCard_Christmas";
    template_christmas_4.recommendation = 8.5;
    [basicTemplates addObject:template_christmas_4];
    //New Year Day 1
    TemplateInfo *template_nyd_1 = [TemplateInfo new];
    template_nyd_1.ID = @"c961aaf3-0155-416c-8e84-3b5216e7e177";
    template_nyd_1.name = @"NewYearDay_1";
    template_nyd_1.desc = @"Card_hy_new_year_1";
    template_nyd_1.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"NewYearDay_1_362_570.jpg"]);
    template_nyd_1.category = @"GreetingCard_NewYearDay";
    template_nyd_1.recommendation = 8.5;
    [basicTemplates addObject:template_nyd_1];
    //New Year Day 2
    TemplateInfo *template_nyd_2 = [TemplateInfo new];
    template_nyd_2.ID = @"3a7cb5ca-c5b3-4afc-9c01-1633a1092da5";
    template_nyd_2.name = @"NewYearDay_2";
    template_nyd_2.desc = @"Card_hy_new_year_2";
    template_nyd_2.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"NewYearDay_2_362_570.jpg"]);
    template_nyd_2.category = @"GreetingCard_NewYearDay";
    template_nyd_2.recommendation = 8.5;
    [basicTemplates addObject:template_nyd_2];
    //New Year Day 3
    TemplateInfo *template_nyd_3 = [TemplateInfo new];
    template_nyd_3.ID = @"68a69ccb-3c46-4982-a83d-1e194a12cfb2";
    template_nyd_3.name = @"NewYearDay_3";
    template_nyd_3.desc = @"Card_zoe_new_year_1";
    template_nyd_3.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"NewYearDay_3_362_570.jpg"]);
    template_nyd_3.category = @"GreetingCard_NewYearDay";
    template_nyd_3.recommendation = 8.5;
    [basicTemplates addObject:template_nyd_3];
    //New Year Day 4
    TemplateInfo *template_nyd_4 = [TemplateInfo new];
    template_nyd_4.ID = @"fa4af1c2-8aaa-483a-b680-ecfaa64f3d8b";
    template_nyd_4.name = @"NewYearDay_4";
    template_nyd_4.desc = @"Card_zoe_new_year_2";
    template_nyd_4.thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"NewYearDay_4_362_570.jpg"]);
    template_nyd_4.category = @"GreetingCard_NewYearDay";
    template_nyd_4.recommendation = 8.5;
    [basicTemplates addObject:template_nyd_4];

    
    return basicTemplates;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [[ShareEngine sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    //NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  [[ShareEngine sharedInstance] handleOpenURL:url];
    
}

#pragma PushNotification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * tempToken = [deviceToken description];
    token = [tempToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [[token componentsSeparatedByString:@" "] componentsJoinedByString:@"" ];
    NSLog(@"got string token %@", token);
    user.deviceToken = token;
    if (!user.ID) {
        logonViewController.deviceToken = token;
    } else {
        [self updateUserDeviceToken];
    }
}

- (void)updateUserDeviceToken {
    NSString *updateAccountService = @"/services/user/update";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,updateAccountService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",user.ID];
    NSString *deviceTokenString = [[NSString alloc] initWithFormat:@"deviceToken=%@",user.deviceToken];
    NSString *parameterString = [[NSString alloc] initWithFormat:@"%@&%@",IDString,deviceTokenString];
    [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    // set badge to nil when data download.
    //TODO
    [self handleNotification:userInfo];
    //application.applicationIconBadgeNumber = 0;
}

- (void)handleNotification:(NSDictionary *)dict {
    NotificationMessage *notification = [NotificationMessage new];
    notification.type = @"1";
    if ([dict objectForKey:@"name"]) {
        notification.content = [[NSString alloc] initWithFormat:@"%@ 加入了您的邀请",[dict objectForKey:@"name"]];
    } else {
        notification.content = @"";
    }
    if ([dict objectForKey:@"date"]) {
        notification.date = [dict objectForKey:@"date"];
    } else {
        notification.date = @"";
    }
    if ([dict objectForKey:@"time"]) {
        notification.time = [dict objectForKey:@"time"];
    } else {
        notification.time = @"";
    }
    if ([dict objectForKey:@"eventID"]) {
        notification.eventUUID = [dict objectForKey:@"eventID"];
        EventInfo *event = [database getEvent:notification.eventUUID];
        notification.pic = event.template.thumbnail;
        notification.user = event.user.userID;
    } else {
        notification.eventUUID = @"";
        notification.pic = nil;
        notification.user = @"";
    }
    
    [database insertNotification:notification];
}


@end
