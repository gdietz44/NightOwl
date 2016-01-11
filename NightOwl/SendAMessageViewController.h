//
//  SendAMessageViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/27/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@class SendAMessageViewController;
@protocol SendAMessageViewControllerDelegate <NSObject>
- (void)sendAMessageViewController:(SendAMessageViewController *)samvc
                    didContactUser:(User *)user
                       withMessage:(NSString *)messageText;

@end

@interface SendAMessageViewController : UIViewController
- (id)initWithDelegate:(id<SendAMessageViewControllerDelegate>)delegate
         userToContact:(User *)user;
@end
