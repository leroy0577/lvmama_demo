//
//  QuickControl.h
//  lChatDemo
//
//  Created by qianfeng on 14-8-25.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickControl : NSObject

@end

//为UIButton添加一个快速创建按钮的方法

@interface UIButton (QuickControl)

+ (id)systemoButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

//快速创建图片按钮的方法
+ (id)imageButtonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image background:(NSString *)background target:(id)target action:(SEL)action;

@end

//快速创建输入框的方法
@interface UITextField (QuickControl)

+ (id)textFieldWithFrmae:(CGRect)frame image:(NSString *)image secureTextEntry:(BOOL)secureTextEntry placeholder:(NSString *)placeholder;

@end

@interface UIImageView (QuickControl)

+ (id)imageViewWithFrame:(CGRect)frame imageFile:(NSString *)imageFile;

@end

//UILabel添加一个快速创建标签的方法
@interface UILabel (QuickControl)
+(id)labelWithFrame:(CGRect)frame
               text:(NSString*)text;
@end