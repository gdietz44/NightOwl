//
//  ConversationViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ConversationViewController;
@protocol ConversationViewControllerDelegate

- (void)conversationViewController:(ConversationViewController *)conversationViewController
             didUpdateConversation:(NSArray *)conversation
                          withUser:(User *)user;

@end

@interface ConversationViewController : UIViewController
- (id)initWithDelegate:(id<ConversationViewControllerDelegate>)delegate
          withConversation:(NSArray *)convo
              withUser:(User *)user
      withAutoresponse: (BOOL)autoresponse;

@property (nonatomic) NSMutableArray *currentConversation;

- (void)reloadTable;

@end

