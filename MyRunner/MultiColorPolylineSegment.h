//
//  MultiColorPolylineSegment.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/1/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <MapKit/MapKit.h>

// Render each segment of the run. The color is going to denote the speed.
@interface MultiColorPolylineSegment : MKPolyline

@property (nonatomic, strong) UIColor *color;

@end
