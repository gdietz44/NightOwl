//
//  MessageTableViewCell.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "MessageTableViewCell.h"
@interface MessageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *sharedClassesLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithUser:(NSString *)user
                sharedClasses:(NSString *)sharedClasses
                        message:(NSString *)status
                         image:(UIImage *)image {
    self.userLabel.text = user;
    self.messageLabel.text = status;
    self.sharedClassesLabel.text = sharedClasses;
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height / 2;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.layer.borderWidth = 0;
    self.profileView.image = image;
}

@end
