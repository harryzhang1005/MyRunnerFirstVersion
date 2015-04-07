//
//  BadgeEarnStatus.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Run;
@class Badge;

/*
 What's this class?
 
 First, Badge is symbol/标志 of different place/spot on the route. Badge is not Awards.
 
 Second, What's mean by earnRun, silverRun, goldRun, and bestRun?
 earnRun    : 跑步距离超过或等于当前徽标代表的距离，平均速度是相对最慢的
 silverRun  : 跑步距离超过或等于当前徽标代表的距离，平均速度相对于earnRun是silver系数水平
 goldRun    : 跑步距离超过或等于当前徽标代表的距离，平均速度相对于earnRun是gold系数水平
 bestRun    : 跑步距离超过或等于当前徽标代表的距离，平均速度是最快的
 
 Design an algorithm to calculate the run levels based on badge.
 */
@interface BadgeEarnStatus : NSObject

@property (nonatomic, strong) Badge *badge;

// run levels based on current badge: earn, silver, gold, best
@property (nonatomic, strong) Run   *earnRun;   // spped is basic  level based on current badge (match current badge first Run object)
@property (nonatomic, strong) Run   *silverRun; // speed is silver level based on earnRun and current badge
@property (nonatomic, strong) Run   *goldRun;   // speed is gold   level based on earnRun and current badge
@property (nonatomic, strong) Run   *bestRun;   // speed is best   level based on current badge

@end
