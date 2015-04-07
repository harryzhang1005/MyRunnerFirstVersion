//
//  BadgesTableViewController.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Each badge will occupy one of these cells, with its image on the left and a description of when you earned the badge, or what you need to earn it.
 The two small silver and gold spaceship icons, in case the user earned those levels.
 */
@interface BadgesTableViewController : UITableViewController

// the result of calling earnStatusesForRuns: in the BadgeController
@property (nonatomic, strong) NSArray   *earnStatusArray;

@end
