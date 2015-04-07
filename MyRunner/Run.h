//
//  Run.h
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Run : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;      // in meters
@property (nonatomic, retain) NSNumber * duration;      // in seconds
@property (nonatomic, retain) NSDate * timestamp;       // in Date
@property (nonatomic, retain) NSOrderedSet *locations;  // one run : many Location objects

@end

// not using
@interface Run (CoreDataGeneratedAccessors)

- (void)insertObject:(Location *)value inLocationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationsAtIndex:(NSUInteger)idx;
- (void)insertLocations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationsAtIndex:(NSUInteger)idx withObject:(Location *)value;
- (void)replaceLocationsAtIndexes:(NSIndexSet *)indexes withLocations:(NSArray *)values;
- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(Location *)values;
- (void)removeLocations:(Location *)values;

@end
