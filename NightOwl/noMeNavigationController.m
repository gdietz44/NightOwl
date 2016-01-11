//
//  noMeNavigationController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "noMeNavigationController.h"
#import "noModalNavigationController.h"
#import "MeViewController.h"
#import "AddClassesViewController.h"

@interface noMeNavigationController () <MeViewControllerDelegate, AddClassesViewControllerDelegate, noModalNavigationControllerDelegate>

@end

@implementation noMeNavigationController
- (id)init {
    MeViewController* mvc = [[MeViewController alloc] initWithDelegate:self];
    if (self = [super initWithRootViewController:mvc]) {
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


#pragma mark - MeNavigationControllerDelegate Methods
- (void)meViewControllerDidSelectAddClassButton:(MeViewController *)meViewController {
    AddClassesViewController* acvc = [[AddClassesViewController alloc] initWithDelegate:self];
    noModalNavigationController *modal = [[noModalNavigationController alloc] initWithRootViewController:acvc withDelegate:self];
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)AddClassesViewController:(AddClassesViewController *)addClassesViewController
                     didAddClass:(NSString *)class {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *classesArr = [defaults objectForKey:@"Classes"];
    if(classesArr && ![classesArr containsObject:class]) {
        NSMutableArray *newClasses = [NSMutableArray arrayWithArray:classesArr];
        [newClasses addObject:class];
        NSArray *sorted = [newClasses sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [defaults setObject:sorted forKey:@"Classes"];
    } else if (![classesArr containsObject:class]) {
        NSArray *newClasses = [NSArray arrayWithObject:class];
        [defaults setObject:newClasses forKey:@"Classes"];
    }
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didDismissNoModalNavigationController:(noModalNavigationController *)noModalNavigationController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
