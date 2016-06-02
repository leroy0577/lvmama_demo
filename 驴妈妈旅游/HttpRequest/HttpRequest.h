//
//  HttpRequest.h
//  NSURLConnectionReview
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject <NSURLConnectionDataDelegate>
{
    //封装NSURLConnection
    NSURLConnection *_urlConnnection;
}
//保存下载的数据
@property (retain,nonatomic) NSMutableData *downloadData;
//保存传入的方法
// weak修饰的属性有一个特点
//  当对象被释放的时候target自动设置为nil
@property (weak,nonatomic) id target;
@property (assign,nonatomic) SEL action;
@property (copy,nonatomic) NSString *urlString;

//参数1: 传入下载的网址
//参数2和3: 传入下载完成之后调用的方法
-(id)initWithURLString:(NSString*)urlString
                    target:(id)target
                    action:(SEL)action;
@end
