//
//  ClassListParser.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/16/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassList;

@interface ClassListParser : NSObject <NSXMLParserDelegate>

@property (nonatomic) ClassList *classList;

@end
