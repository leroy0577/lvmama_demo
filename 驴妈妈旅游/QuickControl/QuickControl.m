//
//  QuickControl.m
//  lChatDemo
//
//  Created by qianfeng on 14-8-25.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "QuickControl.h"

@implementation QuickControl

@end

@implementation UIButton (QuickControl)

+ (id)systemoButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//快速创建图片按钮的方法
+ (id)imageButtonWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image background:(NSString *)background target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:background] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end

@implementation UIImageView (QuickControl)

+ (id)imageViewWithFrame:(CGRect)frame imageFile:(NSString *)imageFile
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageFile];
    return imageView;
}

@end

//快速创建输入框的方法
@implementation UITextField (QuickControl)

+ (id)textFieldWithFrmae:(CGRect)frame image:(NSString *)image secureTextEntry:(BOOL)secureTextEntry placeholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setBackground:[UIImage imageNamed:image]];
    textField.secureTextEntry = secureTextEntry;
    textField.placeholder = placeholder;
    return textField;
    
}

@end

@implementation UILabel (QuickControl)

+(id)labelWithFrame:(CGRect)frame
               text:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    return label;
}

@end
