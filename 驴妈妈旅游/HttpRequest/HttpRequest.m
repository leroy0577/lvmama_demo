//
//  HttpRequest.m
//  NSURLConnectionReview
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HttpRequest.h"
#import "DataCache.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation HttpRequest
//参数1: 传入下载的网址
//参数2和3: 传入下载完成之后调用的方法
-(id)initWithURLString:(NSString*)urlString
                    target:(id)target
                    action:(SEL)action
{
    if(self = [super init])
    {
        //为了下载完成之后回调
        _target = target;
        _action = action;
        _urlString = urlString;
        
        //初始化downloadData
        _downloadData = [[NSMutableData alloc] init];
        
        //缓存中读取数据
        NSData *data = [DataCache readDataWithUrlString:_urlString];
        //两种可能: 能读到数据,读不到数据
        if(data != nil) //读到数据了
        {
            //NSLog(@"read from cache");
            [_downloadData appendData:data];
            
            if([self.target respondsToSelector:self.action])
            {
                [self.target performSelector:self.action withObject:self];
            }
        }
        else    //没有从缓存读到数据
        {
            //开始下载数据
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _urlConnnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        }
    }
    return self;
}

//接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadData appendData:data];
}

//接收完成---(核心和重点)
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //保存数据
    [DataCache saveData:_downloadData urlString:_urlString];
    
    
    
    //数据已经下载完成,存储 _downloadData
    //  需要调用target和action指定的方法
    
    //首先判断方法是否存在?
    if([self.target respondsToSelector:self.action])
    {
        //执行self.target对象的self.action方法
        //传递了一个参数 self
        
        //遇到问题
        //下载完成之后通知界面对象
        //  如果界面被释放的时候, target指向无效的内存, 出现错误 BAD_ADDRESS
        
        
        [self.target performSelector:self.action withObject:self];
    }
    
}

@end
