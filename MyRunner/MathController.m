//
//  MathController.m
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "MathController.h"
#import "Location.h"
#import "MultiColorPolylineSegment.h"

static bool const isMetric = YES;
static float const metersInKm = 1000;
static float const metersInMile = 1609.344;

@implementation MathController

+(NSString *)stringifyDistance: (float)meters
{
    float unitDivider;
    NSString *unitName;
    
    if (isMetric) {
        unitName = @"km";
        unitDivider = metersInKm;
    } else {
        unitName = @"mi";
        unitDivider = metersInMile;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (meters/unitDivider), unitName];
}

+(NSString *)stringifySeconds: (int)seconds usingLongFormat:(BOOL)longFormat
{
    int remainingSeconds = seconds;
    int hours = remainingSeconds / 3600;
    remainingSeconds -= hours * 3600;
    int minutes = remainingSeconds / 60;
    remainingSeconds -= minutes * 60;
    
    if (longFormat)
    {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
        
    } else {
        
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }//
}

+(NSString *)stringifyAvgPaceFromDistance:(float)meters overTime:(int)seconds
{
    if (seconds == 0 || meters == 0.) {
        return @"0";
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    float unitMultiplier;
    NSString *unitName;
    
    if (isMetric) {
        unitName = @"min/km";
        unitMultiplier = metersInKm;
    } else {
        unitName = @"min/mi";
        unitMultiplier = metersInMile;
    }
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

// create color-coded segment array
+(NSArray *)colorSegmentsForLocations:(NSArray *)locations
{
    // make array of all speeds, find slowest and fastest
    NSMutableArray *speeds = [NSMutableArray array];
    double slowestSpeed = DBL_MAX;
    double fastestSpeed = 0.0;
    NSUInteger locationsCount = locations.count;
    
    for (int i = 1; i < locationsCount; i++)
    {
        Location *preLoc = [locations objectAtIndex:(i - 1)];
        Location *nxtLoc = [locations objectAtIndex:i];
        
        CLLocation *preLocCL = [[CLLocation alloc] initWithLatitude:preLoc.latitude.doubleValue longitude:preLoc.longitude.doubleValue];
        CLLocation *nxtLocCL = [[CLLocation alloc] initWithLatitude:nxtLoc.latitude.doubleValue longitude:nxtLoc.longitude.doubleValue];
        
        double distance = [nxtLocCL distanceFromLocation:preLocCL];
        double time = [nxtLoc.timestamp timeIntervalSinceDate:preLoc.timestamp];
        double speed = distance / time;
        
        slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed;
        fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed;
        
        [speeds addObject:@(speed)];
    }
    
    // now knowing the slowest and fastest
    double meanSpeed = (slowestSpeed + fastestSpeed) / 2;
    
    CGFloat slowR = 1.0f, slowG = 20/255.0f, slowB = 44/255.0f;     // RGB for red (slowest)
    CGFloat midR = 1.0f, midG = 215/255.0f, midB = 0.0f;            // RGB for yellow (middle)
    CGFloat fastR = 0.0f, fastG = 146/255.0f, fastB = 78/255.0f;    // RGB for green (fastest)
    
    NSMutableArray *colorSegments = [NSMutableArray array];
    
    // In this loop, you determine the value of each pre-calculated speed, relative to the full range of speeds. This ratio then determines the UIColor to apply to the segment.
    for (int i = 1; i < locationsCount; i++)
    {
        Location *preLoc = [locations objectAtIndex:(i-1)];
        Location *nxtLoc = [locations objectAtIndex:i];
        
        CLLocationCoordinate2D coords[2];
        coords[0].latitude = preLoc.latitude.doubleValue;
        coords[0].longitude = preLoc.longitude.doubleValue;
        coords[1].latitude = nxtLoc.latitude.doubleValue;
        coords[1].longitude = nxtLoc.longitude.doubleValue;
        
        NSNumber *speed = [speeds objectAtIndex:(i-1)];
        UIColor *color = [UIColor blackColor];
        
        // between red and yellow
        if (speed.doubleValue < meanSpeed) {
            double ratio = (speed.doubleValue - slowestSpeed) / (meanSpeed - slowestSpeed);
            CGFloat red = slowR + ratio * (midR - slowR);
            CGFloat green = slowG + ratio * (midG - slowG);
            CGFloat blue = slowB + ratio * (midB - slowB);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        } else { // between yellow and green
            double ratio = (speed.doubleValue - meanSpeed) / (fastestSpeed - meanSpeed);
            CGFloat red = midR + ratio * (fastR - midR);
            CGFloat green = midG + ratio * (fastG - midG);
            CGFloat blue = midB + ratio * (fastB - midB);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        }
        MultiColorPolylineSegment *segment = [MultiColorPolylineSegment polylineWithCoordinates:coords count:2];
        segment.color = color;
        
        [colorSegments addObject:segment];
    }
    
    return colorSegments;
}

@end
