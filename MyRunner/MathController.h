//
//  MathController.h
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Use the altitude information from the location updates in NewRunController to figure out how hilly the route is.
 
 If you’re up for a pure-math challenge, try blending the segment colors more smoothly by averaging a segment’s speed with that of the segment before it.
 
 */

@interface MathController : NSObject

+(NSString *)stringifyDistance: (float)meters;
+(NSString *)stringifySeconds: (int)seconds usingLongFormat:(BOOL)longFormat;
+(NSString *)stringifyAvgPaceFromDistance:(float)meters overTime:(int)seconds;

+(NSArray *)colorSegmentsForLocations:(NSArray *)locations;

@end
