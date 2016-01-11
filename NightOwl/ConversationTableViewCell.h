//
//  ConversationTableViewCell.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface ConversationTableViewCell : UITableViewCell
- (CGSize)getMessageSize;
- (void)configureCellWithMessage:(Message *)messageObj;
@end
