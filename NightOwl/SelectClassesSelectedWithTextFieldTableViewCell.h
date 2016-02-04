//
//  SelectClassesSelectedWithTextFieldTableViewCell.h
//  NightOwl
//
//  Created by Griffin Dietz on 1/30/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiLineFieldTextView.h"

@interface SelectClassesSelectedWithTextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) IBOutlet MultiLineFieldTextView *statusLabel;
- (NSString *)getName;
- (void)configureCell:(NSString *)className withStatus:(NSString *)status withIndex:(NSUInteger)index;

@end
