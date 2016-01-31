//
//  SelectClassesTableViewCellSelected.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectClassesTableViewCellSelected : UITableViewCell
- (NSString *)getName;
@property (weak, nonatomic) IBOutlet UIButton *activeButton;
- (void)configureCell:(NSString *)className withStatus:(NSString *)status;
@end
