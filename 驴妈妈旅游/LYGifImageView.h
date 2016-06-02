//
//  LYGifImageView.h
//  LYGifImage
//
//  Created by qianfeng on 14-11-1.
//  Copyright (c) 2014年 li yun cai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AnimatedGifFrame :NSObject
{
    NSData * data;
    NSData * header;
    //延迟
    double delay;
    //处理方法
    int disposalMethod;
    //区域
    CGRect area;
}
@property(nonatomic) NSData * data;
@property(nonatomic) NSData * header;
@property(nonatomic) double delay;
@property(nonatomic) int disposalMethod;
@property(nonatomic) CGRect area;
@end
@interface LYGifImageView : UIImageView
{
    NSData * GIF_pointer;
    NSMutableData * GIF_buffer;
    NSMutableData * GIF_screen;
    NSMutableData * GIF_global;
    NSMutableArray * GIF_frames;
    
    int GIF_sorted;
    int GIF_colorS;
    int GIF_colorC;
    int GIF_colorF;
    int animatedGifDelay;
    int dataPointer;
}
@property (nonatomic ,retain) NSMutableArray * GIF_frames;

//-(id)initWithGifImage:(UIImage *)image;
-(id)initWithGIFFile:(NSString *)gifFilePath;
-(id)initWithGIFData:(NSData *)gifImageDta;

-(void)loadImageData;

+(NSMutableArray *)getGifFrames:(NSData *)gifImageData;
+(BOOL)isGifImage:(NSData *)imageData;

-(void)decodeGIF:(NSData *)GIFData;
-(void)GIFReadExtensions;
-(void)GIFReadDescriptor;
- (bool) GIFGetBytes:(int)length;
- (bool) GIFSkipBytes: (int) length;
- (NSData*) getFrameAsDataAtIndex:(int)index;
- (UIImage*) getFrameAsImageAtIndex:(int)index;

@end
