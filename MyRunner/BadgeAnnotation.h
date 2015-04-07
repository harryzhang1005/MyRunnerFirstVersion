//
//  BadgeAnnotation.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/3/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <MapKit/MapKit.h>

/*
 Annotations are how map views can display point data like this.
 1. A class adopting MKAnnotation handles the data side of the annotation.
    Your class provides a coordinate to allow the map to know where to put the annotation.
 2. A class extending MKAnnotationView arranges the incoming data from an MKAnnotation into this visual form.
 
 So you'll begin by arranging the badge data into an array of objects conforming to MKAnnotation.
 Then you'll use the MKMapViewDelegate method mapView:viewForAnnotation: to translate that data into MKAnnotationViews.
 
 */

@interface BadgeAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString  *imageName;

@end
