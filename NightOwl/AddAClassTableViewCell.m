//
//  AddAClassTableViewCell.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "AddAClassTableViewCell.h"

@interface AddAClassTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@end

@implementation AddAClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithClassName:(NSString *)className {
    self.classLabel.text = className;
}

- (NSString *)getClassName {
    return self.classLabel.text;
}

@end
