//
//  HGDateFormatter.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/3/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGDateFormatter : NSDateFormatter

// expensive, so cache it
+(instancetype)sharedDateFormatter;

@end
