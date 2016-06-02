//
//  LocationCenter.m
//  驴妈妈旅游
//
//  Created by luoyang on 14-10-14.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "LocationCenter.h"

@implementation LocationCenter

+(LocationCenter *)sharedInstans
{
    static LocationCenter *dc = nil;
    if (dc == nil) {
        dc = [[[self class] alloc] init];
    }
    return dc;
}
@end
