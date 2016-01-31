//
//  SelectClassesViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectClassesViewController;
@protocol SelectClassesViewControllerDelegate <NSObject>

- (void)selectClassesViewController:(SelectClassesViewController *)selectClassesViewController
                  didSelectClass:(NSString *)selectedClass;

@end

@interface SelectClassesViewController : UIViewController
- (id)initWithDelegate:(id<SelectClassesViewControllerDelegate>)delegate;
@end
