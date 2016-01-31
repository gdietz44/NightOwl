//
//  MessageData.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/27/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "MessageData.h"
#import "User.h"
#import "Message.h"

@implementation MessageData
- (id)init {
    if (self = [super init]) {
        self.conversations = [[NSMutableDictionary alloc] initWithCapacity:4];
        NSArray *names = @[@"Cristian F.",@"Lucy S.",@"Miguel H.",@"Aaron B."];
        NSArray *statuses = @[@"Would love to check answers and get help on #7",@"Anyone else in wilbur working on this?? Down to have company/check answers",@"Tryna check answers - I've got everything but #10",@"About halfway through but would love company (and I've got snacks)"];
        NSArray *locations = @[@"Donner",@"Otero",@"Theta Delta Chi",@"Kappa Alpha"];
        NSArray *latitudes = @[@37.423794, @37.424292, @37.420943, @37.420455];
        NSArray *longitiudes = @[@-122.165411, @-122.162328, @-122.170099, @-122.174012];
        NSArray *sharedClassIndices = @[@[@0, @1], @[@0], @[@1, @3], @[@2]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *currentClasses = [defaults objectForKey:@"Classes"];
        NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < [names count]; i++) {
            NSString *name = [names objectAtIndex:i];
            NSString *status = [statuses objectAtIndex:i];
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
            User *newUser = [[User alloc] initWithName:name status:status locationName:locationName latitude:latitude.doubleValue longitude:longitude.doubleValue imageName:imageName contacted:YES sharedClasses:sharedClasses];
            [users addObject:newUser];
        }
        
        NSArray *messageText = @[@[@"Hey! Want to work together? Looks like we're stuck on the same problem.", @"Sounds great. Meet at Tresidder?", @"I'll head there now.", @"Here. I'm in a purple shirt and I have a bright orange backpack."], @[@"Hi. Saw you're looking to check answers and are also in Wilbur. So am I. Can we meet up?",@"I'm headed to a group project meeting now. Can we meet in an hour?", @"Sure. Lemme know when you're done", @"Will do.", @"Done.", @"Still up to meet?", @"Yeah.", @"Want to just meet in the Otero lounge?", @"Sounds good. Be there in a sec."], @[@"Also stuck on #10. Want to try to work through it together?",@"That'd be great! Where you want to go?", @"Old Union work?", @"Works for me. Meet you there in 10?", @"Sounds great. See you in a bit."], @[@"You have snacks!? Haha. I'm there! Jk. Also about halfway done and some company would be nice. Mind if I join you?",@"Please do. I'm in KA right now, but happy to move elsewhere. Does Old Union work?", @"Yeah! Sounds great!"]];
        NSArray *senders = @[@[@NO, @YES, @NO, @NO],@[@YES, @NO, @YES, @NO, @NO, @NO, @YES, @YES, @NO], @[@NO, @YES, @YES, @NO, @YES], @[@YES, @NO, @YES]];
        for (int i = 0; i < 4; i ++) {
            NSArray *currMessageText = [messageText objectAtIndex:i];
            NSArray *currSenderList = [senders objectAtIndex:i];
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            for (int j = 0; j < currMessageText.count; j++) {
                BOOL currSenderMe = [currSenderList[j] boolValue];
                User *user = currSenderMe ? nil : users[i];
                Message *message = [[Message alloc] initWithUser:user message:currMessageText[j]];
                [messages addObject:message];
            }
            [self.conversations setObject:messages forKey:((User *)users[i]).name];
        }
        self.contactedUsers = users;
    }
    return self;
}
@end
