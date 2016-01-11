//
//  MeViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeViewController;
@protocol MeViewControllerDelegate <NSObject>

- (void)meViewControllerDidSelectAddClassButton:(MeViewController *)meViewController;

@end


@interface MeViewController : UIViewController

- (id)initWithDelegate:(id<MeViewControllerDelegate>)delegate;

@end
