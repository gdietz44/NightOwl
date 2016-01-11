//
//  MessageTableViewCell.h
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
- (void)configureCellWithUser:(NSString *)user
                sharedClasses:(NSString *)sharedClasses
                      message:(NSString *)status
                        image:(UIImage *)image;
@end
