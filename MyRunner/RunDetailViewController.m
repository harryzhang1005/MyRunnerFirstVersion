//
//  DetailViewController.m
//  MyRunner
//
//  Created by Harvey Zhang on 3/31/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "RunDetailViewController.h"
#import "Run.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import "MathController.h"
#import "MultiColorPolylineSegment.h"
#import "Badge.h"
#import "BadgeController.h"
#import "BadgeAnnotation.h"
#import "HGDateFormatter.h"

// Maps out a run with a color-coded polyline and custom annotations at each checkpoint.

@interface RunDetailViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView  *mapView;
@property (nonatomic, weak) IBOutlet UILabel    *distLabel;
@property (nonatomic, weak) IBOutlet UILabel    *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel    *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel    *paceLabel;

@property (nonatomic, weak) IBOutlet UIImageView    *badgeImageView;
@property (nonatomic, weak) IBOutlet UIButton       *infoButton;

@end

@implementation RunDetailViewController

-(void)setRun:(Run *)run
{
    if (_run != run)
    {
        _run = run;
    
        [self configureView];
    }
}

-(void)configureView
{
    self.distLabel.text = [MathController stringifyDistance:self.run.distance.floatValue];
    self.dateLabel.text = [[HGDateFormatter sharedDateFormatter] stringFromDate:self.run.timestamp];
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", [MathController stringifySeconds:self.run.duration.intValue usingLongFormat:YES]];
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@", [MathController stringifyAvgPaceFromDistance:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    
    [self loadMap];
    
    // show the badge that was last earned
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.run.distance.floatValue];
    self.badgeImageView.image = [UIImage imageNamed:badge.imageName];
}

// switch mode
-(IBAction)displayModeToggled:(UISwitch *)sender
{
    self.badgeImageView.hidden = !sender.isOn;
    self.infoButton.hidden = !sender.isOn;
    self.mapView.hidden = sender.isOn;
}

-(IBAction)infoButtonPressed:(id)sender
{
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.run.distance.floatValue];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:badge.name message:badge.msg
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Rendering the map needs three steps.
 */
-(void)loadMap
{
    if (self.run.locations.count > 0)
    {
        self.mapView.hidden = NO;
        
        // Step-1: set the map region/bounds so that only the run is shown and not the entire world.
        [self.mapView setRegion:[self mapRegion]];
        
        // Step-2: set the lines over the map to indidate where the run went
        //[self.mapView addOverlay:[self polyLine]];
        NSArray *colorSegmentArray = [MathController colorSegmentsForLocations:self.run.locations.array]; // color-coded line
        [self.mapView addOverlays:colorSegmentArray];
        
        // Step-3: Style it. tell the map view to add all the annotations
        // Annotations are models used to annotate coordinates on the map.
        // Implement mapView:viewForAnnotation: on MKMapViewDelegate to return the annotation view for each annotation.
        [self.mapView addAnnotations:[[BadgeController defaultController] annotationsForRun:self.run]];
        
    } else { // no locations were found
        
        self.mapView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, this run has no locations saved."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


/* An MKCoordinateRegion represents the display region for the map, and you define it by supplying a center point and
 a span that defines horizontal and vertical ranges.
 
 For example, my jog may be quite zoomed in around my short reoute, while my more athletic friend's map will appear more zoomed out to
 cover all the distance she traveled.
 
 It's important to also account for a little padding, so that the route doesn't crowd all the way to the edge of the map.
*/
-(MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    
    Location *initLocation = self.run.locations.firstObject;
    float minLat = initLocation.latitude.floatValue;
    float minLng = initLocation.longitude.floatValue;
    float maxLat = minLat;
    float maxLng = minLng;
    
    for (Location *location in self.run.locations)
    {
        float tmpLat = location.latitude.floatValue;
        float tmpLng = location.longitude.floatValue;
        
        if (tmpLat < minLat) {
            minLat = tmpLat;
        }
        if (tmpLat > maxLat) {
            maxLat = tmpLat;
        }
        
        if (tmpLng < minLng) {
            minLng = tmpLng;
        }
        if (tmpLng > maxLng) {
            maxLng = tmpLng;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f;   // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f;  // 10% padding
    
    return region;
}

// Lastly, you need to define the coordinates for the polyline.
-(MKPolyline *)polyLine
{
    NSUInteger locationsCount = self.run.locations.count;
    CLLocationCoordinate2D coords[locationsCount];
    
    for (int i = 0; i < locationsCount; i++)
    {
        Location *location = [self.run.locations objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:locationsCount];
}

#pragma mark - MKMapViewDelegate methods
/*
 Whenever the map comes across a request to add an overlay, it should check if it's a MKPolyline.
 If so, it should use a renderer that will make a black line.
 
 An overlay is something that is drawn on top of a map view. 
 A polyline is such an overlay and represents a line drawn from a series of location points.
 
 overlay param is an object that conforms to <MKOverlay> protocol, such as MKPolyline, MultiColorPolylineSegment
 */
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    /* v1
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blackColor];   // always using black color
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    */
    
    // v2
    if ([overlay isKindOfClass:[MultiColorPolylineSegment class]])
    {
        MultiColorPolylineSegment *polyLine = (MultiColorPolylineSegment *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color; // using customized color
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

// Called every time the map wants a view for the given annotation.
// Return a view and the map view will then handle the logic of putting it in the right place on the map.
// In this case, you take an incoming annotation and tell the map how to render it. Notice that the title and subtitle properties don't make an appearance -- that rendering happens automatically inside Map Kit.
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    BadgeAnnotation *badgeAnnotation = (BadgeAnnotation *)annotation;
    
    static NSString *annID = @"checkpoint";
    MKAnnotationView *annView = [mapView dequeueReusableAnnotationViewWithIdentifier:annID];
    if (!annView)
    {
        annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annID];
        annView.image = [UIImage imageNamed:@"mapPin"];
        annView.canShowCallout = YES;
    }
    
    UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
    badgeImageView.image = [UIImage imageNamed:badgeAnnotation.imageName];
    badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    annView.leftCalloutAccessoryView = badgeImageView;
    
    return annView;
}





@end
