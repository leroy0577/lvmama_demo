//
//  DataCache.m
//  FreeLimit1413
//
//  Created by mac on 14-6-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "DataCache.h"

#import "NSString+Hashing.h"

@implementation DataCache

////缓存有效时间, 默认值1小时
static NSTimeInterval invalidTime = 60*60;

//保存数据
//  保存data指向数据保存到文件中
+(void)saveData:(NSData *)data
      urlString:(NSString *)urlString
{
    //保存到哪儿?
        //创建文件夹
    //文件名是什么?
    //  http://www.baidu.com/232.php
    //  http://www.baidu.com/oc/232.php
    //  需要把网址转换成一个字符串作为文件名
    
    //<1>创建缓存文件夹
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/DataCache/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    //<2>先把网址转化为字符串
    //  MD5编码
    //  每一个字符串计算MD5编码值, 不同的字符串的MD5编码值是不同的(不绝对)
    //获取24个字符的MD5编码值
    //NSString *md5 = [urlString MD5Hash];
    
    NSString *file = [NSString stringWithFormat:@"%@%@",path,[urlString MD5Hash]];
    BOOL b = [data writeToFile:file atomically:YES];
    //NSLog(@"write cache = %d",b);
}

//读取数据
//  从缓存中读取数据
+(NSData *)readDataWithUrlString:(NSString *)urlString
{
    //<1>获取文件名
    NSString *file = [NSString stringWithFormat:@"%@/Documents/DataCache/%@",NSHomeDirectory(),[urlString MD5Hash]];
    
    //暂时没考虑缓存时间
    //考虑缓存文件时间是否太长
    //  假定: 缓存时间是1个小时
    //思路:
    //  获取当前时间和文件的最后修改时间, 计算时间差
    //      如果时间差大于1小时, 缓存无效了
    
    //计算时间间隔
    // typedef double NSTimeInterval;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[self lastModifyTimeByFile:file]];
    if(timeInterval > invalidTime)
    {
        //说明缓存超过有效时间
        return nil;
    }
    
    //<2>读取数据
    NSData *data = [[NSData alloc] initWithContentsOfFile:file];
    
    
    return data;
}

//获取文件的最后修改时间的
+(NSDate *)lastModifyTimeByFile:(NSString *)file
{
    //获取文件的多个属性
    NSDictionary *attributeDict = [[NSFileManager defaultManager]  attributesOfItemAtPath:file error:nil];
    
    //NSLog(@"attributeDict = %@",attributeDict);
    /*
     attributeDict = {
     NSFileCreationDate = "2014-06-28 02:18:51 +0000";
     NSFileExtensionHidden = 0;
     NSFileGroupOwnerAccountID = 20;
     NSFileGroupOwnerAccountName = staff;
     NSFileModificationDate = "2014-06-28 02:18:51 +0000";
     NSFileOwnerAccountID = 501;
     NSFilePosixPermissions = 420;
     NSFileReferenceCount = 1;
     NSFileSize = 17192;
     NSFileSystemFileNumber = 38729467;
     NSFileSystemNumber = 16777218;
     NSFileType = NSFileTypeRegular;
     }
     */
    
    return attributeDict[@"NSFileModificationDate"];
}

@end
