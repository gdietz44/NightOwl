//
//  User.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/25/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "User.h"

@implementation User
- (id)initWithName:(NSString *)name
            status:(NSString *)status
      locationName:(NSString *)locationName
          latitude:(double)latitude
         longitude:(double)longitude
         imageName:(NSString *)imageName
         contacted:(BOOL)contacted
     sharedClasses:(NSArray *)sharedClasses {
    if (self = [super init]) {
        self.contacted = contacted;
        self.name = name;
        self.status = status;
        self.locationName = locationName;
        self.coordinates = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        self.distance = [self.coordinates distanceFromLocation:[[CLLocation alloc] initWithLatitude:37.426256 longitude:-122.171715]];
        self.image = [UIImage imageNamed:imageName];
        self.sharedClasses = sharedClasses;
    }
    return self;
}
@end
