//
//  Badge.m
//  MyRunner
//
//  Created by Harvey Zhang on 4/2/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

#import "Badge.h"

@implementation Badge

-(instancetype)initWithName:(NSString *)name msg:(NSString *)msg
                  imageName:(NSString *)imageName distance:(float)dist
{
    if (self = [super init]) {
        _name = name;
        _msg = msg;
        _imageName = imageName;
        _distance = dist;
    }
    return self;
}

/* Sample - If you don't override this method, only output memory address in console
 
 "Badge Info: (name:Earth, msg:\"The Earth is the cradle of the mind, but one cannot live in a cradle forever.\" -- Konstantin Eduardovich Tsiolkovsky, Russian rocket scientist, 1911, imageName:earth.jpg, distance:0.000000)",
 "Badge Info: (name:Earth's Atmosphere, msg:100km above sea level, outer space begins. \"We want to explore. We're curious people. Look back over history, people have put their lives at stake to go out and explore. We believe in what we're doing. Now it's time to go.\" -Eileen Collins, NASA Space Shuttle Commander, imageName:atmosphere.jpg, distance:804.671997)",
 "Badge Info: (name:The Moon, msg:The Moon rotates about its axis in the same time it takes to orbit the Earth, so the same face is always turned toward us. The side facing away is sometimes called the \"dark side,\" but actually it is illuminated just as often-- it's being lit up when the side facing us appears dark. Sorry, Pink Floyd., imageName:moon.jpg, distance:1609.343994)",
 */
-(NSString *)description
{
    return [NSString stringWithFormat:@"Badge Info: (name:%@, msg:%@, imageName:%@, distance:%f)", self.name, self.msg, self.imageName, self.distance];
}

@end
