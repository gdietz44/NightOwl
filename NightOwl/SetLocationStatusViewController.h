//
//  SetLocationStatusViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetLocationStatusViewController;
@protocol SetLocationStatusViewControllerDelegate <NSObject>

- (void)setLocationStatusViewController:(SetLocationStatusViewController *)selectClassesViewController
                       didActivateClass:(NSString *)selectedClass
                           withLocation:(NSString *)location
                              andStatus:(NSString *)status;

@end

@interface SetLocationStatusViewController : UIViewController
- (id)initWithDelegate:(id<SetLocationStatusViewControllerDelegate>)delegate
            classTitle:(NSString *)classTitle
          currLocation:(NSString *)location;
@end
