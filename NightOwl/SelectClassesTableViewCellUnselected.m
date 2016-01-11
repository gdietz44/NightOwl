//
//  SelectClassesTableViewCellUnselected.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/9/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "SelectClassesTableViewCellUnselected.h"

@interface SelectClassesTableViewCellUnselected()
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@end

@implementation SelectClassesTableViewCellUnselected

- (void)awakeFromNib {
    // Initialization code
}

- (NSString *)getName {
    return self.classLabel.text;
}

- (void)configureCell:(NSString *)className {
    self.classLabel.text = className;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

@end
