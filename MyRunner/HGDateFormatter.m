//
//  HGDateFormatter.m
//  MyRunner
//
//  Created by Harvey Zhang on 4/3/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "HGDateFormatter.h"

@implementation HGDateFormatter

+(instancetype)sharedDateFormatter
{
    static HGDateFormatter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
        [_sharedInstance setDateStyle:NSDateFormatterMediumStyle];
    });
    
    return _sharedInstance;
}

@end
