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
@property (nonatomic) NSString *username;
@property (nonatomic) NSArray *statuses;
@property (nonatomic) NSString *locationName;
@property (nonatomic) CLLocation *coordinates;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) UIImage *image;
@property (nonatomic) BOOL contacted;
@property (nonatomic) NSArray *sharedClasses;
@property (nonatomic) BOOL imageDownloaded;

- (id)initWithName:(NSString *)name
          username:(NSString *)username
          statuses:(NSArray *)statuses
      locationName:(NSString *)locationName
          latitude:(double)latitude
         longitude:(double)longitude
         imageName:(NSString *)imageName
         contacted:(BOOL)contacted
     sharedClasses:(NSArray *)sharedClasses;

@end
