//
//  ClassList.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/13/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#include <UIKit/UIKit.h>

@interface ClassList : NSObject

- (id)init;

@property (nonatomic) NSInteger totalNumClasses;
@property (nonatomic) NSMutableArray *subjectArr;
@property (nonatomic) NSMutableDictionary *subjectCountMap;
@property (nonatomic) NSMutableDictionary *subjectCodeMap;
@property (nonatomic) NSMutableArray *classArr;

@end
