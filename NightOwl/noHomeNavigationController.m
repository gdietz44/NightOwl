//
//  ncNavigationController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "noHomeNavigationController.h"
#import "SelectClassesViewController.h"

@interface noHomeNavigationController () <SelectClassesViewControllerDelegate>

@end

@implementation noHomeNavigationController
- (id)init {
    SelectClassesViewController* scvc = [[SelectClassesViewController alloc] initWithDelegate:self];
    if (self = [super initWithRootViewController:scvc]) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationBar.translucent = NO;
        self.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SelectClassesViewControllerDelegate Methods
- (void)selectClassesViewController:(SelectClassesViewController *)selectClassesViewController didSelectClass:(NSString *)selectedClass {
    #pragma unused(selectClassesViewController)
    NSLog(@"%@", selectedClass);
}

@end
