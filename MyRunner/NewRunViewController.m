//
//  NewRunViewController.m
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "NewRunViewController.h"
#import "Run.h"
#import "Location.h"
#import "MathController.h"
#import <MapKit/MapKit.h>
#import "BadgeController.h"
#import "Badge.h"
#import <AudioToolbox/AudioToolbox.h>   // a sound can be played every time your earn a new badge

/*
 1. Measures and tracks your runs using Core Location.
 
 2. Displays real-time (NSTimer) data, like the run's average pace, along with an active map.
 
 3. Maps out a run with a color-coded polyline and custom annotations at each checkpoint.
 
 4. Awards badges for personal progress in distance and speed.
 
 */

static NSString * const detailSegueName = @"ShowRunDetails";

@interface NewRunViewController () <UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property int seconds;      // tracks the duration of the run, in seconds
@property float distance;   // holds the cumulative distance of the run, in meters

// Use Core Location Step-1: Define a location manager
@property (nonatomic, strong) CLLocationManager *locationMgr;    // start or stop reading the user's location
@property (nonatomic, strong) NSMutableArray    *basicLocations; // stores all the basic CLLocation objects that will roll in

// Use Timer Step-1: Define a timer
@property (nonatomic, strong) NSTimer           *timer;         // will fire each second and update UI accordingly

@property (nonatomic, strong) Run *run; // preserve current run object

@property (nonatomic, weak) IBOutlet UILabel    *promptLabel;
@property (nonatomic, weak) IBOutlet UILabel    *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel    *distLabel;
@property (nonatomic, weak) IBOutlet UILabel    *paceLabel;

@property (nonatomic, weak) IBOutlet UIButton    *startBtn;
@property (nonatomic, weak) IBOutlet UIButton    *stoppBtn;

@property (nonatomic, weak) IBOutlet MKMapView   *mapView;

@property (nonatomic, strong) Badge *upcomingBadge; // you will win the coming badge
@property (nonatomic, weak) IBOutlet UILabel        *nextBadgeLabel;
@property (nonatomic, weak) IBOutlet UIImageView    *nextBadgeImageView;

@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.startBtn.hidden = NO;
    self.promptLabel.hidden = NO;
    
    self.timeLabel.text = @"";
    self.timeLabel.hidden = YES;
    
    self.distLabel.hidden = YES;
    self.paceLabel.hidden = YES;
    self.stoppBtn.hidden = YES;
    
    self.mapView.hidden = YES;
    
    self.nextBadgeImageView.hidden = YES;
    self.nextBadgeLabel.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Use Timer Step-3: invalidate the timer when no need it anymore
    [self.timer invalidate];
}

// Start running
-(IBAction)startBtnPressed:(id)sender
{
    // hide the start UI
    self.startBtn.hidden = YES;
    self.promptLabel.hidden = YES;
    
    // show the running UI
    self.timeLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.paceLabel.hidden = NO;
    self.stoppBtn.hidden = NO;
    
    self.seconds = 0;
    self.distance = 0;
    self.basicLocations = [NSMutableArray array];
    
    // Use Timer Step-2: Create and Start the timer to real-time tracking
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
    [self startLocationUpdates];
    
    self.mapView.hidden = NO;
    
    self.nextBadgeLabel.hidden = NO;
    self.nextBadgeImageView.hidden = NO;
}

// Stop running
-(IBAction)stopBtnPressed:(id)sender
{
    // Use Core Location Step-4: Stop updating location
    [self.locationMgr stopUpdatingLocation];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Handle Run Record" delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Save", @"Discard", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // Save
        [self saveRun];
        [self performSegueWithIdentifier:detailSegueName sender:nil]; // will fire call prepareForSegue:sender:
    } else if (buttonIndex == 1) {    // Discard
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        //
    }
}

#pragma mark - Navigation
// prepare somthing before fire a segue
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [[segue destinationViewController] setRun:self.run]; // pass run object to detail vc
}

#pragma mark - Helpers
// Timer callback function
-(void)eachSecond
{
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", [MathController stringifySeconds:self.seconds usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"Distance: %@", [MathController stringifyDistance:self.distance]];
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@", [MathController stringifyAvgPaceFromDistance:self.distance overTime:self.seconds]];
    
    self.nextBadgeLabel.text = [NSString stringWithFormat:@"%@ until %@!", [MathController stringifyDistance:(self.upcomingBadge.distance - self.distance)], self.upcomingBadge.name];
    [self checkNextBadge];
}

-(void)checkNextBadge
{
    Badge *nextBadge = [[BadgeController defaultController] nextBadgeForDistance:self.distance];
    
    if (self.upcomingBadge && ![nextBadge.name isEqualToString:self.upcomingBadge.name]) {
        [self playSuccessSound];
    }
    
    self.upcomingBadge = nextBadge;
    self.nextBadgeImageView.image = [UIImage imageNamed:nextBadge.imageName];
}

// learn how to play a sound
-(void)playSuccessSound
{
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/success.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    // also vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

// Use Core Location Step-2: Create location manager and start updating location
-(void)startLocationUpdates
{
    if (self.locationMgr == nil) // be lazy
    {
        self.locationMgr = [[CLLocationManager alloc] init];
        
        self.locationMgr.delegate = self;
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        
        // The activityType parameter is made specifically for an app like this. It intelligently helps the device to save some power throughout a user’s run, say if they stop to cross a road.
        self.locationMgr.activityType = CLActivityTypeFitness;
        
        /* Movement threshold for new events
         You set a distanceFilter of 10 meters. As opposed to the activityType, this parameter doesn’t affect battery life. The activityType is for readings, and the distanceFilter is for the reporting of readings.
         A higher distanceFilter could reduce the zigging and zagging and thus give you a more accurate line. Unfortunately, too high a filter would pixelate your readings. That’s why 10 meters is a good balance.
         */
        self.locationMgr.distanceFilter = 10; // meters
    }
    
    [self.locationMgr startUpdatingLocation];
}

// Save run into MyRunner.sqlite
-(void)saveRun
{
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run"
                                                inManagedObjectContext:self.managedObjectContext];
    newRun.distance = [NSNumber numberWithFloat:self.distance];
    newRun.duration = [NSNumber numberWithInt:self.seconds];
    newRun.timestamp = [NSDate date];
    
    NSMutableArray *locationsArray = [NSMutableArray array];
    // CLLocaiton -> Location
    for (CLLocation *location in self.basicLocations)
    {
        Location *locationObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                                 inManagedObjectContext:self.managedObjectContext];
        locationObject.timestamp = location.timestamp;
        locationObject.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        locationObject.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        
        [locationsArray addObject:locationObject];
    }
    
    newRun.locations = [NSOrderedSet orderedSetWithArray:locationsArray];
    
    self.run = newRun;  // preserve the object and pass it to detail view controller
    
    // Save the context
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// Use Core Location Step-3: override location manager delegate method
#pragma mark - CLLocationManagerDelegate method
// Called each time there are new location updates to provide the app
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Usually this array only contains one object, but if there are more, they are ordered by time with the most recent location last.
    for (CLLocation *newLocation in locations)
    {
        NSDate  *eventDate = newLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        /*
         It’s worth a horizontalAccuracy check. If the device isn’t confident it has a reading within 20 meters of the user’s actual location, it’s best to keep it out of your dataset.
         
         Note: This check is especially important at the start of the run, when the device first starts narrowing down the general area of the user. At that stage, it’s likely to update with some inaccurate data for the first few points.
         
         Note: The CLLocation object also contains information on altitude, with a corresponding verticalAccuracy value. As every runner knows, hills can be a game changer on any run, and altitude can affect the amount of oxygen available. A challenge to you, then, is to think of a way to incorporate this data into the app.
         */
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20.0) // Key point
        {
            // update distance
            if (self.basicLocations.count > 0)
            {
                self.distance += [newLocation distanceFromLocation:self.basicLocations.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.basicLocations.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                // update the map region and draw the polyline every time a valid location is found
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500); // 500 m
                [self.mapView setRegion:region animated:YES];
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.basicLocations addObject:newLocation];
        }//EndIf
        
    }//EndLoop
}

#pragma mark - MKMapViewDelegate method
// always use blue color to show running route
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer  *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

@end
