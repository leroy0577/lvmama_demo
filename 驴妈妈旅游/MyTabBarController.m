//
//  MyTabBarController.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()
{
    //UIScrollView *_view;
    
    NSArray * imageArray;
    NSArray * image2Array;
}

@end

@implementation MyTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createMytabBar];
    // Do any additional setup after loading the view.
}
- (void)createMytabBar
{
    _myTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, self.view.frame.size.height)];
    _myTabBar.backgroundColor = [UIColor colorWithRed:235/250.0 green:235/250.0 blue:235/250.0 alpha:1];
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    backImageView.image = [UIImage  imageNamed:@"navBg.png"];
    [_myTabBar addSubview:backImageView];
    
     imageArray =  @[@"tab_1_normal",@"tab_3_normal",@"tab_4_normal",@"tab_5_normal"];
     image2Array = @[@"tab_1_pressed",@"tab_3_pressed",@"tab_4_pressed",@"tab_5_pressed"];

    
    for (int i = 0;  i<4 ; i++) {
        float w = 40;
        float h = 40;
        float x = i * ((280 - 44*4)/3+44) + 30;
        float y = 4;

        UIButton *button = [UIButton imageButtonWithFrame:CGRectMake(x, y, w, h) title:nil image:nil background:imageArray[i] target:self action:@selector(btnClick1:)];
    
        
        button.tag = 300 +i;

        [_myTabBar addSubview:button];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:image2Array[0]] forState:UIControlStateNormal];
        }
    }
    
    [self.view addSubview:_myTabBar];
    
}
- (void)btnClick1:(UIButton *)sender
{
    for (int i = 0; i<4; i++) {
     
        UIButton * button = (UIButton *)[self.view viewWithTag:i+300];
        [button setImage:nil forState:UIControlStateNormal];
        NSLog(@"%@",button);
       
//        button.enabled = YES;
    }
   
    [sender setImage:[UIImage imageNamed:image2Array[sender.tag - 300]] forState:UIControlStateNormal];
//    sender.enabled = NO;
    self.selectedIndex = sender.tag -300;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

