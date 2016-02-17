//
//  MessagesViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"

@interface MessagesViewController : UIViewController
@property (nonatomic) MessageData *messageData;
- (void) loadData;
@end