//
//  LocationCenter.h
//  驴妈妈旅游
//
//  Created by luoyang on 14-10-14.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationCenter : NSObject
@property (nonatomic,assign)float lat;
@property (nonatomic,assign)float lng;
+(LocationCenter *)sharedInstans;
@end
