//
//  MyTabBarController.h
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBarController : UITabBarController
//功能:给标签栏添加一个标签项
//参数1:传入一个视图控制器的名字
//参数2:传入界面的标题
//参数3:传入界面图片的路径
//- (UIViewController *)addViewController:(NSString *)name title:(NSString *)title image:(NSString *)image;
@property (retain,nonatomic) UIView *myTabBar;
@end
