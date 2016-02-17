//
//  noTabBarController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "noMessagesTabNavigationController.h"

@interface noTabBarController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic) noMessagesTabNavigationController *messagesController;

@end
