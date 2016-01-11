//
//  UpdateLocationStatusViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/24/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UpdateLocationStatusViewController;
@protocol UpdateLocationStatusViewControllerDelegate <NSObject>

- (void)updateLocationStatusViewController:(UpdateLocationStatusViewController *)selectClassesViewController
                            didUpdateClass:(NSString *)selectedClass
                              withLocation:(NSString *)location
                                 andStatus:(NSString *)status;

- (void)updateLocationStatusViewController:(UpdateLocationStatusViewController *)selectClassesViewController
                        didDeactivateClass:(NSString *)selectedClass;

@end

@interface UpdateLocationStatusViewController : UIViewController
- (id)initWithDelegate:(id<UpdateLocationStatusViewControllerDelegate>)delegate
            classTitle:(NSString *)classTitle
          currLocation:(NSString *)location
            currStatus:(NSString *)status;
@end
