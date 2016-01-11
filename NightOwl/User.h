//
//  User.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/25/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreLocation;

@interface User : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *locationName;
@property (nonatomic) CLLocation *coordinates;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) UIImage *image;
@property (nonatomic) BOOL contacted;
@property (nonatomic) NSArray *sharedClasses;

- (id)initWithName:(NSString *)name
            status:(NSString *)status
      locationName:(NSString *)locationName
          latitude:(double)latitude
         longitude:(double)longitude
         imageName:(NSString *)imageName
         contacted:(BOOL)contacted
     sharedClasses:(NSArray *)sharedClasses;

@end
