//
//  noModalNavigationController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "noModalNavigationController.h"

@interface noModalNavigationController ()

@property (nonatomic, weak) id<noModalNavigationControllerDelegate> modalDelegate;

@end

@implementation noModalNavigationController
- (id)initWithRootViewController:(UIViewController *)rootViewController
                    withDelegate:(id<noModalNavigationControllerDelegate>)delegate {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationBar.translucent = NO;
        self.navigationBar.barStyle = UIBarStyleBlack;
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Close-Gray"] style:UIBarButtonItemStyleDone target:self action:@selector(didCancel)]; //initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancel)];
        rootViewController.navigationItem.rightBarButtonItem = button;
        rootViewController.navigationItem.hidesBackButton = YES;
        self.modalDelegate = delegate;
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


#pragma mark - Navigation
- (void)didCancel {
    [self.modalDelegate didDismissNoModalNavigationController:self];
}

@end
