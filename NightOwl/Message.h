//
//  Message.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/27/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject
@property (nonatomic) User *sender;
@property (nonatomic) NSString *message;
- (id)initWithUser:(User *)sender message:(NSString *)message;
@end
