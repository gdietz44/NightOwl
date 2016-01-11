//
//  AddAClassTableViewCell.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAClassTableViewCell : UITableViewCell
- (void)configureCellWithClassName:(NSString *)className;
- (NSString *)getClassName;
@end
