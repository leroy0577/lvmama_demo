//
//  cityModel.h
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-24.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityModel : NSObject
@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * id;
@property (copy,nonatomic) NSString * subName;
@property (copy,nonatomic) NSString * isHot;
@property (copy,nonatomic) NSString * pinyin;

@end

@interface changeModel : NSObject 
@property (copy,nonatomic) NSString *pinyin;
@property (copy,nonatomic) NSString *station_code;
@property (copy,nonatomic) NSString *station_id;
@property (copy,nonatomic) NSString *station_name;

@end
