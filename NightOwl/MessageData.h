//
//  MessageData.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/27/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject
@property (nonatomic) NSMutableDictionary *conversations;
@property (nonatomic) NSMutableArray *contactedUsers;
@end
