//
//  AppDelegate.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "NearbyViewController.h"
#import "MyLvmamaViewController.h"
#import "MoreViewController.h"

#import "MyTabBarController.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    [self createTabBar];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)createTabBar
{
    MyTabBarController *mtbc = [[MyTabBarController alloc] init];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:hvc];
    
    NearbyViewController *nvc = [[NearbyViewController alloc] init];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:nvc];
    
    MyLvmamaViewController *mvc = [[MyLvmamaViewController alloc] init];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:mvc];
    
    MoreViewController *movc = [[MoreViewController alloc] init];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:movc];
    
    mtbc.viewControllers = @[nc1,nc2,nc3,nc4];

    self.window.rootViewController = mtbc;
    
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

@end
