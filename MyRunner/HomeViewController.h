//
//  HomeViewController.h
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <UIKit/UIKit.h>

/* What's to learn from this app?
 
 1. Measures and tracks your runs using Core Location.
    # CLLocationManager
    [self.locationMgr startUpdatingLocation]; [self.locationMgr stopUpdatingLocation];
    # override location mangager delegate method
    -(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
 
 2. Displays real-time data, like the run's average pace, along with an active map.
    # NSTimer
    [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
    [self.timer invalidate];
    # load map three steps
    Step-1: set the map region/bounds so that only the run is shown and not the entire world. (Required)
    Step-2: set the lines over the map to indidate where the run went. (Required)
    Step-3: Style it. tell the map view to add all the annotations. (Optional)
    # how to play a sound
 
 3. Maps out a run with a color-coded polyline and custom annotations at each checkpoint (match badge's distance spot).
    # subclass
    MultiColorPolylineSegment : MKPolyline
    BadgeAnnotation : MKPointAnnotation
    # override map view delegate methods
    mapView:rendererForOverlay:
    mapView:viewForAnnotation:
 
 4. Badges and Awards for personal progress in distance (Badge) and speed (Award).
    math calculator and algorithm in BadgeController
 
 5. Core Data
    # three key properties
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;   // like a DB connection
    # read data from core data db
    # write data into core data db
 
 ## Ideas to take it to the next level:
 1. Add a table for a user's past runs
 2. Try using the speeds for sements of a run to earn badges.
    - For example, if you run your fastest 5 km in hte middle of a 10 km run, how do you count that towards a silver or gold 5 km badge?
    - Find the average pace between each checkpoint and display it on the MKAnnotationView callout
    - Add badges for lifetime achievements, for instance, running a total of 100 km in a week, 1000 km all-time, etc.
    - Sync a user's run data with a server.
 */

@interface HomeViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
