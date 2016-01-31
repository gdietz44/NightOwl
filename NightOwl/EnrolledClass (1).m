//
//  EnrolledClass.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "EnrolledClass.h"

@implementation EnrolledClass
- (id)initWithClass:(NSString *)classTitle {
    if(self = [super init]) {
        self.classTitle = classTitle;
        self.status = @"";
        self.location = @"";
        self.active = NO;
    }
    return self;
}
@end
