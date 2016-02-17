//
//  noMessagesTabNavigationController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "noMessagesTabNavigationController.h"
#import "MessagesViewController.h"
@interface noMessagesTabNavigationController ()

@property (nonatomic) MessagesViewController *mvc;

@end

@implementation noMessagesTabNavigationController
- (id)init {
    MessagesViewController* mvc = [[MessagesViewController alloc] init];
    self.mvc = mvc;
    if (self = [super initWithRootViewController:mvc]) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationBar.translucent = NO;
        self.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

- (void) loadData {
    [self.mvc loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
