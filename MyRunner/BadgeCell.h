//
//  BadgeCell.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel    *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel    *despLabel;

@property (nonatomic, weak) IBOutlet UIImageView    *badgeIV;
@property (nonatomic, weak) IBOutlet UIImageView    *silverIV;
@property (nonatomic, weak) IBOutlet UIImageView    *goldIV;

@end
