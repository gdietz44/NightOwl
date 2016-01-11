//
//  SelectClassesTableViewCellSelected.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "SelectClassesTableViewCellSelected.h"

@interface SelectClassesTableViewCellSelected()
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SelectClassesTableViewCellSelected

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

- (void)configureCell:(NSString *)className withStatus:(NSString *)status {
    self.classLabel.text = className;
    self.statusLabel.text = status;
}

@end
