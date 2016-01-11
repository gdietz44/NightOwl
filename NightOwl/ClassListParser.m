//
//  ClassListParser.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/16/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "ClassListParser.h"
#import "ClassList.h"

@interface ClassListParser()
    @property (nonatomic) NSString *currSubject;
    @property (nonatomic) NSString *lastSubject;
    @property (nonatomic) NSString *currCode;
    @property (nonatomic) BOOL onSubject;
    @property (nonatomic) BOOL onCode;
@end

@implementation ClassListParser

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(self.onSubject) {
        self.currSubject = [self.currSubject stringByAppendingString:string];
    } else if (self.onCode) {
        self.currCode = [self.currCode stringByAppendingString:string];
    }
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"courses"]) {
        //Initialize the class list
        self.classList = [[ClassList alloc] init];
        self.onSubject = NO;
        self.onCode = NO;
    } else if([elementName isEqualToString:@"subject"]) {
        self.currSubject = @"";
        self.onSubject = YES;
        self.onCode = NO;
    } else if([elementName isEqualToString:@"code"]) {
        self.currCode = @"";
        self.onSubject = NO;
        self.onCode = YES;
    } else if([elementName isEqualToString:@"course"]) {
        self.onSubject = NO;
        self.onCode = NO;
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"subject"]) {
        self.onSubject = NO;
        if(![self.currSubject isEqualToString:self.lastSubject]) {
            [self.classList.subjectArr addObject:self.currSubject];
            self.lastSubject = self.currSubject;
        }
    } else if([elementName isEqualToString:@"code"]) {
        self.onCode = NO;
    } else if([elementName isEqualToString:@"course"]) {
        self.classList.totalNumClasses++;
        [self.classList.classArr addObject:[self.currSubject stringByAppendingString:self.currCode]];
        if([self.classList.subjectCodeMap objectForKey:self.currSubject]) {
            NSMutableArray *array = [self.classList.subjectCodeMap objectForKey:self.currSubject];
            [array addObject:self.currCode];
            [self.classList.subjectCodeMap setObject:array forKey:self.currSubject];
            
            NSNumber *count = [NSNumber numberWithInteger:(((NSNumber *)[self.classList.subjectCountMap objectForKey:self.currSubject]).integerValue + 1)];
            [self.classList.subjectCountMap setObject:count forKey:self.currSubject];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:self.currCode, nil];
            [self.classList.subjectCodeMap setObject:array forKey:self.currSubject];
            [self.classList.subjectCountMap setObject:@1 forKey:self.currSubject];
        }
        
    }
}

@end
