//
//  BadgeController.m
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "BadgeController.h"
#import "Badge.h"
#import "BadgeEarnStatus.h"
#import "Run.h"
#import "Location.h"
#import "MathController.h"
#import "BadgeAnnotation.h"
#import <MapKit/MapKit.h>


// The factors by which a user has to speed up to earn those versions of the badge
float const silverMultiplier = 1.05;    // 5%  speed increase
float const goldMultiplier = 1.10;      // 10% speed increase


@interface BadgeController ()

@property (nonatomic, strong) NSArray   *badges; // parse the JSON text file into an array of objects.

@end

@implementation BadgeController

+(BadgeController *)defaultController
{
    static BadgeController * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
    return _sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _badges = [self getBadges];
    }
    return self;
}

-(NSArray *)getBadges
{
    NSMutableArray *badgeObjects = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"badges" ofType:@"txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    
    // parse JSON file to get the badges
    NSArray *badgeDictArray = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:&error];
    for (NSDictionary *dict in badgeDictArray)
    {
        NSString *name = [dict objectForKey:@"name"];
        NSString *info = [dict objectForKey:@"information"];
        NSString *imgName = [dict objectForKey:@"imageName"];
        float dist = [[dict objectForKey:@"distance"] floatValue];
        Badge *badge = [[Badge alloc] initWithName:name msg:info imageName:imgName distance:dist];
        
        [badgeObjects addObject:badge];
    }
    
    //NSLog(@"Badges array:%@", badgeObjects);
    
    return badgeObjects;
}


/* The algorithm
 This method compares all the user’s runs to the distance requirements for each badge, making the associations and returning all the BadgeEarnStatus objects in an array.
 
 To do this, the first time a user reaches the badge it finds a earnRunSpeed, which becomes a reference to see if the user improved enough to qualify for the silver or gold versions.
 */
-(NSArray *)earnStatusesForRuns:(NSArray *)runs
{
    NSMutableArray *earnStatuses = [NSMutableArray array];
    
    for (Badge *badge in self.badges)
    {
        BadgeEarnStatus *earnStatus = [BadgeEarnStatus new];
        earnStatus.badge = badge;
        double earnRunSpeed = 0.0;
        
        for (Run *run in runs)
        {
            // self-designed an algorithm to assign run level
            if (run.distance.floatValue > badge.distance)
            {
                if (!earnStatus.earnRun) { // this is when the badge was first earned
                    earnStatus.earnRun = run;
                    earnRunSpeed = earnStatus.earnRun.distance.doubleValue / earnStatus.earnRun.duration.doubleValue;
                }
                
                double runSpeed = run.distance.doubleValue / run.duration.doubleValue;
                
                // does it deserve gold?
                if (!earnStatus.goldRun && runSpeed > earnRunSpeed * goldMultiplier) { earnStatus.goldRun = run; }
                
                // does it deserve silver?
                if (!earnStatus.silverRun && runSpeed > earnRunSpeed * silverMultiplier) { earnStatus.silverRun = run; }

                // is it the best for this distance?
                if (!earnStatus.bestRun) {
                    earnStatus.bestRun = run;
                } else {
                    double bestRunSpeed = earnStatus.bestRun.distance.doubleValue / earnStatus.bestRun.duration.doubleValue;
                    if (runSpeed > bestRunSpeed) { // update best run
                        earnStatus.bestRun = run;
                    }
                }
            }//EndRunIf
            
        }//EndRunsLoop
        
        [earnStatuses addObject:earnStatus];
        
    }//EndBadgesLoop
    
    return earnStatuses;
}

// get the best badge based on the distance
-(Badge *)bestBadgeForDistance: (float)distance
{
    Badge *bestBadge = self.badges.firstObject;
    
    for (Badge *badge in self.badges)
    {
        if (distance < badge.distance) {
            break;
        }
        bestBadge = badge;
    }
    
    return bestBadge;
}

// The badge that is next to be won
-(Badge *)nextBadgeForDistance: (float)distance
{
    Badge *nextBadge;
    
    for (Badge *badge in self.badges)
    {
        nextBadge = badge;
        if (distance < badge.distance) {
            break;
        }
    }
    
    return nextBadge;
}

/*
 This method loops over all the location points in the run and keeps a cumulative distance for the run. When the cumulative distance passes the next badge’s threshold, a BadgeAnnotation is created. This annotation provides the coordinates of where the badge was earned, the badge’s name, the distance through the run and the badge image name.
 */
-(NSArray *)annotationsForRun:(Run *)run
{
    NSMutableArray *annotations = [NSMutableArray array];
    
    int locationIndex = 1; float distance = 0.0;
    NSUInteger locationsCount = run.locations.count;
    
    for (Badge *badge in self.badges)
    {
        if (badge.distance > run.distance.floatValue) {
            break;
        }
        
        while (locationIndex < locationsCount)
        {
            Location *preLoc = [run.locations objectAtIndex:(locationIndex - 1)];
            Location *nxtLoc = [run.locations objectAtIndex:locationIndex];
            
            // Location -> CLLocation to calculate the distance using distanceFromLocation: method
            CLLocation *preLocCL = [[CLLocation alloc] initWithLatitude:preLoc.latitude.doubleValue longitude:preLoc.longitude.doubleValue];
            CLLocation *nxtLocCL = [[CLLocation alloc] initWithLatitude:nxtLoc.latitude.doubleValue longitude:nxtLoc.longitude.doubleValue];
            
            distance += [nxtLocCL distanceFromLocation:preLocCL];
            locationIndex++;
            
            if (distance >= badge.distance)
            {
                BadgeAnnotation *annotation = [[BadgeAnnotation alloc] init];
                annotation.coordinate = nxtLocCL.coordinate; // won the badge in this coordinate
                annotation.title = badge.name;
                annotation.subtitle = [MathController stringifyDistance:badge.distance];
                annotation.imageName = badge.imageName;
                [annotations addObject:annotation];
                break;
            }
        }//EndWhile
        
    }//EndFor
    
    return annotations;
}

@end
