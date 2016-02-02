//
//  AppDelegate.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Lookback/Lookback.h>

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    noTabBarController *notbc = [[noTabBarController alloc] init];
    self.window.rootViewController = notbc;
    
    self.tabBarController = notbc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [Lookback_Weak setupWithAppToken:@"ohdshJX2zNXBCzoeX"];
    [Lookback_Weak sharedLookback].shakeToRecord = YES;
    [Lookback_Weak sharedLookback].feedbackBubbleVisible = NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSArray *classes = @[@"CS 147", @"ECON 1", @"MATH 51"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:classes forKey:@"Classes"];
        [defaults setBool:YES forKey:@"HasLaunchedOnce"];
        [defaults synchronize];
    }
    [GMSServices provideAPIKey:@"AIzaSyDc3lx4F8nTMTdwswL54UVfwIg8STI-gpg"];
    
    // Add the login view controller as the root controller of the app window
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.window setRootViewController:loginVC];
    // Above is new login code
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Unused AppDelegate Methods
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
