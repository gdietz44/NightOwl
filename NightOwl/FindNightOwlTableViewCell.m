//
//  FindNightOwlTableViewCell.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/24/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "FindNightOwlTableViewCell.h"
@interface FindNightOwlTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation FindNightOwlTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTitle:(NSString *)title
                        status:(NSString *)status
                         image:(UIImage *)image {
    self.userLabel.text = title;
    self.statusLabel.text = status;
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height / 2;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.layer.borderWidth = 0;
    self.profileView.image = image;
}

@end
