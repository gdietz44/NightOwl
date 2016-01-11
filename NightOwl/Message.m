//
//  Message.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/27/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "Message.h"

@implementation Message
- (id)initWithUser:(User *)sender
           message:(NSString *)message {
    if (self = [super init]) {
        self.sender = sender;
        self.message = message;
    }
    return  self;
}
@end
