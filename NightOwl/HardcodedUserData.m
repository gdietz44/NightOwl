//
//  HardcodedUserData.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/25/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "HardcodedUserData.h"
#import "User.h"

@implementation HardcodedUserData

- (id)init {
    if (self = [super init]) {
        NSArray *names = @[@"Andres C.",@"Steph T.",@"Kemi B.",@"Aashna L.",@"Shirin V.",@"Xavier J.",@"Dan P.",@"John K.",@"Sam T.",@"Chenye X.",@"Alex B.",@"Chris T. ",@"Ian G.",@"Katie S.",@"Grace D.",@"Jim S. ",@"Sasha L.",@"Catherine V.",@"Allan D.",@"Saunders F.",@"Caitlin H.",@"Kyle A.",@"Clay S.",@"Nikhil P.",@"Jenai F.",@"Margaret T.",@"Arun V."];
        NSArray *statuses = @[@"Just getting started on this...FML",@"Tryna check answers!",@"Struggling with 4 and 7 -- hmu to work on those!",@"Just #7 left -- hmu if you're also stuck!",@"Who else wants to check answers?",@"Good up till #11! :D",@"Hmu if trying to check answers!",@"Looking for a study buddy! (just starting now)",@"Anyone else have a tough time on #7?",@"Having trouble getting started!",@"Just a few left -- anyone else almost done?",@"Love the prof but ermahgod this pset!! ",@"Just 7 and 10 left!",@"Who else hasn't started...lol ",@"Looking to check answers! :)",@"#7 is killing me! Who wants to work through it together? ",@"Looking to check answers!",@"I've got everything but #3. Down to check answers as well.",@"Really confused on 2c - anyone in my boat?",@"Looking to go over the practice midterm tonight",@"HELP I am stuck on everything but #1-3. Can it be break?",@"Would love to think through #5 and #7 with someone who has also attempted them",@"Looking to check answers, but stuck on #8. Happy to help you with the rest of the pset though :)",@"Hoping to check answers real quick.",@"Did anyone get #7 or #8? I have the rest!",@"Late to the game and just getting started - if anyone wants to join",@"Does anyone understand how to do #7b???"];
        NSArray *locations = @[@"Green Library",@"Wilbur (Cedro)",@"Lagunita (Eucalipto)", @"Starbucks",@"Crothers",@"Huang",@"FloMo (Alondra)",@"Green Library",@"Huang ",@"Stern (Donner)",@"Branner Hall",@"French House",@"Sigma Nu",@"Columbae ",@"FroSoCo",@"Muwekma",@"Green Library",@"Kappa Alpha Theta",@"680",@"Xanadu",@"Pi Phi",@"Phi Psi",@"FloMo (Mirlo)",@"Chi Theta Chi",@"Synergy",@"The Ranch",@"Enchanted Brocolli Forest"];
        NSArray *latitudes = @[@37.426799, @37.424133, @37.425028, @37.424105, @37.425554, @37.4279, @37.422302, @37.426799, @37.427867, @37.42428, @37.425181, @37.419562, @37.422274, @37.423062, @37.425963, @37.423425, @37.426799, @37.421349, @37.420487, @37.422248, @37.421856, @37.419984, @37.422302, @37.422419, @37.419455, @37.419989, @37.419646];
        NSArray *longitiudes = @[@-122.167066, @-122.162149, @-122.176813, @-122.170884, @-122.165306, @-122.174306, @-122.171154, @-122.167066, @-122.174306, @-122.166281, @-122.162685, @-122.166806, @-122.168423, @-122.168756, @-122.180216, @-122.169043, @-122.167066, @-122.161785, @-122.171421, @-122.169288, @-122.16238, @-122.167301, @-122.171154, @-122.165842, @-122.169216, @-122.170993, @-122.173907];
        NSArray *sharedClassIndices = @[@[@0, @1], @[@0], @[@1, @3], @[@2], @[@0, @4], @[@2, @4], @[@1], @[@0], @[@1, @4], @[@0], @[@0], @[@1, @2], @[@4], @[@3], @[@2, @3], @[@1], @[@3, @4], @[@0, @3], @[@1], @[@0, @2], @[@1], @[@2], @[@0], @[@3], @[@4], @[@0], @[@1, @2]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *currentClasses = [defaults objectForKey:@"Classes"];
        NSMutableArray *mutableUsers = [[NSMutableArray alloc] initWithCapacity:[names count]];
        for (int i = 0; i < [names count]; i++) {
            NSString *name = [names objectAtIndex:i];
            NSString *locationName = [locations objectAtIndex:i];
            NSNumber *latitude = [latitudes objectAtIndex:i];
            NSNumber *longitude = [longitiudes objectAtIndex:i];
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[name substringToIndex:[name rangeOfString:@" "].location]];
            NSMutableArray *sharedClasses = [[NSMutableArray alloc] init];
            for (NSNumber *index in ([(NSArray *)sharedClassIndices objectAtIndex:i])) {
                if (index.integerValue < [currentClasses count]) {
                    [sharedClasses addObject:[currentClasses objectAtIndex:index.integerValue]];
                }
            }
            User *newUser = [[User alloc] initWithName:name username:name statuses:statuses locationName:locationName latitude:latitude.doubleValue longitude:longitude.doubleValue imageName:imageName contacted:NO sharedClasses:sharedClasses];
            [mutableUsers addObject:newUser];
        }
        self.users = mutableUsers;
    }
    return self;
}

@end
