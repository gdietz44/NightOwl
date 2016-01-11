//
//  FindNightOwlTableViewCell.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/24/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindNightOwlTableViewCell : UITableViewCell
- (void)configureCellWithTitle:(NSString *)title
                        status:(NSString *)status
                         image:(UIImage *)image;
@end
