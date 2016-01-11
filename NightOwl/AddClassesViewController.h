//
//  AddClassesViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddClassesViewController;
@protocol AddClassesViewControllerDelegate <NSObject>

- (void)AddClassesViewController:(AddClassesViewController *)addClassesViewController
                     didAddClass:(NSString *)class;

@end

@interface AddClassesViewController : UIViewController

- (id)initWithDelegate:(id<AddClassesViewControllerDelegate>)delegate;

@end
