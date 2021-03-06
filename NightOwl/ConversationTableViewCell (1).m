//
//  ConversationTableViewCell.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "User.h"

#define kMessageWidth 200
#define kBufferWidth 44

@interface ConversationTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *otherUserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *meImageView;
@property (nonatomic) UITextView *messageView;
@end

@implementation ConversationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithMessage:(Message *)messageObj {
    self.meImageView.layer.cornerRadius = self.meImageView.frame.size.height /2;
    self.meImageView.layer.masksToBounds = YES;
    self.meImageView.layer.borderWidth = 0;
    
    self.otherUserImageView.layer.cornerRadius = self.otherUserImageView.frame.size.height /2;
    self.otherUserImageView.layer.masksToBounds = YES;
    self.otherUserImageView.layer.borderWidth = 0;
    
    // Since we are creating a new UITextfield with every load, set any existing UITextfield instance to nil
    [self.messageView removeFromSuperview];
    self.messageView = nil;
    
    
    // get sender id to configure appearance (if we're sending a message it will appear
    // on the right side, if we received a message the message will be on the left side of the screen)
    BOOL otherUserSentMessage = (messageObj.sender != nil);
    
    // we have to do this in code so we can set the frame once and avoid cut off text
    self.messageView = [[UITextView alloc] init];
    
    // set cell text
    self.messageView.text = messageObj.message;
    
    // set font and text size (I'm using custom colors here defined in a category)
    [self.messageView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    UIColor *fontColor = otherUserSentMessage ? [UIColor darkGrayColor] : [UIColor whiteColor];
    [self.messageView setTextColor:fontColor];
    
    // our messages will be a different color than their messages
    UIColor *backgroundColor = otherUserSentMessage ? [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1] : [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
    
    // I want the cell background to be invisible, and only have the
    // message background be colored
    self.messageView.backgroundColor = backgroundColor;
    self.messageView.layer.cornerRadius = 10.0;
    
    // make the textview fit the content (kMessageWidth = 220, kMessageBuffer = 15 ... buffer is amount of space from edge of cell)
    CGSize newSize = [self.messageView sizeThatFits:CGSizeMake(kMessageWidth, MAXFLOAT)];
    CGRect newFrame;
    
    // since we are placing the message bubbles justified right or left on the screen
    // we determine if this is our message or someone else's message and set the cell
    // origin accordingly... (if the sender of this message (e.g. theirId) is us, then take the width
    // of the cell, subtract our message width and our buffer and set that x position as our origin.
    // this will position messages we send on the right side of the cell, otherwise the other party
    // in our conversation sent the message, so our x position will just be whatever the buffer is.
    float originX = (otherUserSentMessage) ? kBufferWidth : [UIScreen mainScreen].bounds.size.width - newSize.width - kBufferWidth;
        
    // set our origin at our calculated x-point, and y position of 10
    newFrame.origin = CGPointMake(originX, 4);
    
    // set our message width and newly calculated height
    newFrame.size = CGSizeMake(fminf(newSize.width, kMessageWidth), newSize.height);
    
    // set the frame of our textview and disable scrolling of the textview
    self.messageView.frame = newFrame;
    self.messageView.scrollEnabled  = NO;
    self.userInteractionEnabled = NO;
    
    // add our textview to our cell
    [self addSubview:self.messageView];
    
    if (messageObj.sender != nil) {
        self.otherUserImageView.hidden = NO;
        self.otherUserImageView.image = messageObj.sender.image;
        self.meImageView.hidden = YES;
    } else {
        self.meImageView.hidden = NO;
        self.otherUserImageView.hidden = YES;
    }
}

- (CGSize)getMessageSize {
    return [self.messageView sizeThatFits:CGSizeMake(kMessageWidth, MAXFLOAT)];
}

@end
