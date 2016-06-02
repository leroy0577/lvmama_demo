//
//  HomeViewController.h
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "RootViewController.h"
#import "cityModel.h"

@interface HomeViewController : RootViewController
@property (copy ,nonatomic) NSString *cityName;
@property (copy ,nonatomic) NSString *searchCity;
@property (copy ,nonatomic) NSString *subName;
@property (copy ,nonatomic) NSString *station_code;
@property (nonatomic,retain) cityModel *model;
@end
