//
//  noModalNavigationController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class noModalNavigationController;
@protocol noModalNavigationControllerDelegate <NSObject>

- (void)didDismissNoModalNavigationController:(noModalNavigationController *)noModalNavigationController;

@end

@interface noModalNavigationController : UINavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
                    withDelegate:(id<noModalNavigationControllerDelegate>)delegate;

@end
