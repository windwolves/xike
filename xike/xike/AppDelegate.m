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

@implementation AppDelegate {
    UserLogonViewController *logonViewController;
    MainViewController *mainViewController;
    NSString *token;
    XikeDatabase *database;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigation;
    
    [WXApi registerApp:@"wxcefa411f34485347"];//WeiXin App
    database = [[XikeDatabase alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setValue:@"1.0" forKey:@"version"];// Set Version
    if (![defaults boolForKey:@"everLaunched"]) { //check whether first launch or not
        //if it's the first time, then create all tables and set defaults.
        if ([database createAllTables]) {
            [defaults setBool:YES forKey:@"everLaunched"];
            [self setUpBasicTemplate];
            //Register APN service
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            
            logonViewController = [UserLogonViewController new];
            logonViewController.database = database;
            logonViewController.deviceToken = token;
            
            navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
            self.window.rootViewController = navigation;
            
        } else {
            NSLog(@"Tables cannot be created!");
            return NO;
        }
    } else if (![defaults boolForKey:@"isLogin"]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        logonViewController = [UserLogonViewController new];
        logonViewController.database = database;
        logonViewController.deviceToken = token;
        
        navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
        self.window.rootViewController = navigation;
        
    } else {
        //if it's not the first time, then direct to the main view.
        /*
        logonViewController = [UserLogonViewController new];
        logonViewController.database = database;
        logonViewController.deviceToken = token;
        
        navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
        */
        UserInfo *user = [database getUserInfo];
        mainViewController = [MainViewController new];
        mainViewController.database = database;
        mainViewController.user = user;
        navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        self.window.rootViewController = navigation;
    }
    
    [self.window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:0.4];
    return YES;
}

- (BOOL)setUpBasicTemplate {
    //x001
    NSMutableArray *basicTemplates = [NSMutableArray new];
    TemplateInfo *template_001 = [TemplateInfo new];
    template_001.ID = @"ff8845e1-ec9f-4f3e-aeb9-e6b6179817e5";
    template_001.name = @"x001";
    template_001.desc = @"";
    template_001.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x001.jpg"],1.0);
    template_001.category = @"";
    template_001.recommendation = 10;
    [basicTemplates addObject:template_001];
    //x002
    TemplateInfo *template_002 = [TemplateInfo new];
    template_002.ID = @"206cfe3d-3b84-41f4-92d4-cc024e10b033";
    template_002.name = @"x002";
    template_002.desc = @"";
    template_002.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x002.jpg"],1.0);
    template_002.category = @"";
    template_002.recommendation = 10;
    [basicTemplates addObject:template_002];
    //x003
    TemplateInfo *template_003 = [TemplateInfo new];
    template_003.ID = @"e2f76972-cbb4-4cc5-bdf7-6f5e7f30f503";
    template_003.name = @"x003";
    template_003.desc = @"";
    template_003.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x003.jpg"],1.0);
    template_003.category = @"";
    template_003.recommendation = 10;
    [basicTemplates addObject:template_003];
    //x004
    TemplateInfo *template_004 = [TemplateInfo new];
    template_004.ID = @"b879a0d2-5449-4a69-a940-adb86d8c7f8b";
    template_004.name = @"x004";
    template_004.desc = @"";
    template_004.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x004.jpg"],1.0);
    template_004.category = @"";
    template_004.recommendation = 10;
    [basicTemplates addObject:template_004];
    //x005
    TemplateInfo *template_005 = [TemplateInfo new];
    template_005.ID = @"7d7e0b0a-46da-45da-86a6-c0d23db58668";
    template_005.name = @"x005";
    template_005.desc = @"";
    template_005.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x005.jpg"],1.0);
    template_005.category = @"";
    template_005.recommendation = 10;
    [basicTemplates addObject:template_005];
    //x006
    TemplateInfo *template_006 = [TemplateInfo new];
    template_006.ID = @"4576c81a-01ea-42fc-b902-da9a2ebc6109";
    template_006.name = @"x006";
    template_006.desc = @"";
    template_006.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x006.jpg"],1.0);
    template_006.category = @"";
    template_006.recommendation = 10;
    [basicTemplates addObject:template_006];
    //x007
    TemplateInfo *template_007 = [TemplateInfo new];
    template_007.ID = @"76622aa5-de2b-43fb-be26-32471d617de6";
    template_007.name = @"x007";
    template_007.desc = @"";
    template_007.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x007.jpg"],1.0);
    template_007.category = @"";
    template_007.recommendation = 10;
    [basicTemplates addObject:template_007];
    //x008
    TemplateInfo *template_008 = [TemplateInfo new];
    template_008.ID = @"426c0e94-bbb4-406f-8d82-bc5a3cafc15a";
    template_008.name = @"x008";
    template_008.desc = @"";
    template_008.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x008.jpg"],1.0);
    template_008.category = @"";
    template_008.recommendation = 10;
    [basicTemplates addObject:template_008];
    //x009
    TemplateInfo *template_009 = [TemplateInfo new];
    template_009.ID = @"65978137-35aa-4aab-bf55-ac6e97c76006";
    template_009.name = @"x009";
    template_009.desc = @"";
    template_009.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x009.jpg"],1.0);
    template_009.category = @"";
    template_009.recommendation = 10;
    [basicTemplates addObject:template_009];
    //x010
    TemplateInfo *template_010 = [TemplateInfo new];
    template_010.ID = @"0b81a006-eb60-4e43-8724-803aa0faeb6e";
    template_010.name = @"x010";
    template_010.desc = @"";
    template_010.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x010.jpg"],1.0);
    template_010.category = @"";
    template_010.recommendation = 10;
    [basicTemplates addObject:template_010];
    //x011
    TemplateInfo *template_011 = [TemplateInfo new];
    template_011.ID = @"d9865c54-3c36-4c34-98c5-12b901d7f15b";
    template_011.name = @"x011";
    template_011.desc = @"";
    template_011.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x011.jpg"],1.0);
    template_011.category = @"";
    template_011.recommendation = 10;
    [basicTemplates addObject:template_011];
    //x012
    TemplateInfo *template_012 = [TemplateInfo new];
    template_012.ID = @"600b607d-c0eb-4f8a-a9ba-889780995201";
    template_012.name = @"x012";
    template_012.desc = @"";
    template_012.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"x012.jpg"],1.0);
    template_012.category = @"";
    template_012.recommendation = 10;
    [basicTemplates addObject:template_012];
    
    for (TemplateInfo *template in basicTemplates) {
        [database insertTemplate:template];
    }
    return YES;
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

#pragma PushNotification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * tempToken = [deviceToken description];
    token = [tempToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [[token componentsSeparatedByString:@" "] componentsJoinedByString:@"" ];
    NSLog(@"got string token %@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    // set badge to nil when data download.
}

@end
