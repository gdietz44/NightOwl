//
//  EnrolledClass.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnrolledClass : NSObject
@property (nonatomic) NSString *classTitle;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *location;
@property (nonatomic) BOOL active;

- (id)initWithClass:(NSString *)classTitle;

@end
