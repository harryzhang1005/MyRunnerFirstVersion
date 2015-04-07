//
//  BadgeController.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Badge;
@class Run;

// The factors by which a user has to speed up to earn those versions of the badge
extern float const silverMultiplier;
extern float const goldMultiplier;

/*
 
 */
@interface BadgeController : NSObject

+(BadgeController *)defaultController;

-(Badge *)bestBadgeForDistance: (float)distance;
-(Badge *)nextBadgeForDistance: (float)distance;

// runs param is all the user's runs
// return BadgeEarnStatus array
-(NSArray *)earnStatusesForRuns:(NSArray *)runs;

// run param is once run route/object
// return BadgeAnnotation array
-(NSArray *)annotationsForRun:(Run *)run;

@end
