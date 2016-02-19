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
@property (weak, nonatomic) IBOutlet UIView *activeView;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureView;


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
    if ([status isEqual:@""]) {
        self.disclosureView.image = [UIImage imageNamed:@"Disclosure-Gray.png"];
        self.classLabel.textColor = [UIColor colorWithRed:165.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1];
        self.activeButton.hidden = YES;
        self.activeButton.enabled = NO;
        self.activeView.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithRed:165.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1].CGColor;
    } else {
        self.disclosureView.image = [UIImage imageNamed:@"Disclosure-Purple.png"];
        self.classLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.activeButton.hidden = NO;
        self.activeButton.enabled = YES;
        self.activeView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.statusLabel.layer.borderColor = [UIColor colorWithRed:165.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1].CGColor;
    }
}

@end
