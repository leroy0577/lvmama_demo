//
//  DataCache.h
//  FreeLimit1413
//
//  Created by mac on 14-6-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject



//保存数据
//  保存data指向数据保存到文件中
+(void)saveData:(NSData *)data
      urlString:(NSString *)urlString;

//读取数据
//  从缓存中读取数据
+(NSData *)readDataWithUrlString:(NSString *)urlString;

//扩展
//  清空缓存
//  计算缓存大小

@end
