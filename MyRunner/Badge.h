//
//  Badge.h
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import <Foundation/Foundation.h>


//
@interface Badge : NSObject

@property (nonatomic, strong) NSString  *name;      // badge name (i.e., silver, gold)
@property (nonatomic, strong) NSString  *msg;       // a piece of cool/interesting information about the badge
@property (nonatomic, strong) NSString  *imageName; // badge image name
@property float distance;                           // the distance in meters to achieve this badge

-(instancetype)initWithName:(NSString *)name msg:(NSString *)msg
                  imageName:(NSString *)imageName distance:(float)dist;

@end
