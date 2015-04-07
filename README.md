# MyRunnerFirstVersion
Let's play with MapKit.

 What's to learn from this app?
 
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
