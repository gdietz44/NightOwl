//
//  noTabBarController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "noTabBarController.h"
#import "MessagesViewcontroller.h"
#import "noHomeNavigationController.h"
#import "noMeNavigationController.h"
#import "noMessagesTabNavigationController.h"

@interface noTabBarController ()

@end

@implementation noTabBarController

- (id)init {
    if(self = [super init]) {
        noHomeNavigationController* homeNav = [[noHomeNavigationController alloc] init];
        homeNav.tabBarItem.title = @"Home";
        homeNav.tabBarItem.image = [UIImage imageNamed:@"Home-Gray0.5x.png"];
        
        noMessagesTabNavigationController *messagesNav = [[noMessagesTabNavigationController alloc] init];
        messagesNav.tabBarItem.title = @"Messages";
        messagesNav.tabBarItem.image = [UIImage imageNamed:@"Messages-Gray0.5x.png"];
        
        noMeNavigationController *meNav = [[noMeNavigationController alloc] init];
        meNav.tabBarItem.title = @"Me";
        meNav.tabBarItem.image = [UIImage imageNamed:@"Me-Gray0.5x.png"];
        
        NSArray *controllers = [NSArray arrayWithObjects:homeNav, messagesNav, meNav, nil];
        self.viewControllers = controllers;
        self.tabBar.tintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
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
