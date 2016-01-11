//
//  SelectClassesTableViewCellUnselected.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/9/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectClassesTableViewCellUnselected : UITableViewCell
- (NSString *)getName;
- (void)configureCell:(NSString *)className;
@end
