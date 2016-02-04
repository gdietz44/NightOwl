//
//  SelectClassesSelectedWithTextFieldTableViewCell.m
//  NightOwl
//
//  Created by Griffin Dietz on 1/30/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

#import "SelectClassesSelectedWithTextFieldTableViewCell.h"

@interface SelectClassesSelectedWithTextFieldTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *classLabel;


@end

@implementation SelectClassesSelectedWithTextFieldTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getName {
    return self.classLabel.text;
}

- (void)configureCell:(NSString *)className withStatus:(NSString *)status withIndex:(NSUInteger)index {
    [self.statusLabel setPlaceholderText:@"eg Finished everything but problem 7"];
    self.statusLabel.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0);
    self.classLabel.text = className;
    self.statusLabel.text = status;
    self.statusLabel.tag = index;
}

@end
