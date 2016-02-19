//
//  FindNightOwlsViewController.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/24/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"

@interface FindNightOwlsViewController : UIViewController

- (id)initWithClassList:(NSArray *)activeClasses highlightedClassIndex:(NSUInteger)index currentLocation:(CLLocationCoordinate2D)currentLocation;

@end
