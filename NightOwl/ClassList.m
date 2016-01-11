//
//  ClassList.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/13/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "ClassList.h"


@implementation ClassList
-(id) init {
    if(self = [super init]) {
        self.subjectCodeMap = [[NSMutableDictionary alloc] init];
        self.classArr = [[NSMutableArray alloc] init];
        self.subjectArr = [[NSMutableArray alloc] init];
        self.subjectCountMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
