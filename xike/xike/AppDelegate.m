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
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigation;
    
    [WXApi registerApp:@"wxcefa411f34485347"];//WeiXin App
    XikeDatabase *database = [[XikeDatabase alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setValue:@"1" forKey:@"a"];
    if (![defaults boolForKey:@"everLaunched"]) { //check whether first launch or not
        //if it's the first time, then create all tables and set defaults.
        if ([database createAllTables]) {
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
