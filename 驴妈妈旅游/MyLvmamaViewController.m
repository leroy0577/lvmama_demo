//
//  MyLvmamaViewController.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "MyLvmamaViewController.h"
#import "LoginViewController.h"
#import "MyModel.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface MyLvmamaViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    NSString *str;
    
}
@end

@implementation MyLvmamaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createNavBar];
    
    [self myLvmamaPostRequest];
    
    
}

- (void)myLvmamaPostRequest
{
    NSString *loginURL = @"http://api3g.lvmama.com/clutter/client/firstLogIn.do?&udid=355533050871178&osVersion=4.1.1&lvversion=5.3.1&formate=json&secondChannel=ANDROID_360&firstChannel=ANDROID";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:loginURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *subDict = dict[@"data"];
        
        MyModel *model = [[MyModel alloc] init];
            
        [model setValuesForKeysWithDictionary:subDict];
        
        str = model.title;
        [self createScrollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",error);
    }];
}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *loginBackground = [UIImageView imageViewWithFrame:CGRectMake(0, 0, 320, 100) imageFile:@"mine_avatar_bg_unlogin.png"];
    loginBackground.userInteractionEnabled = YES;
    
    [_scrollView addSubview:loginBackground];
    
    UIImageView *play_display = [UIImageView imageViewWithFrame:CGRectMake(8, 20, 60, 60) imageFile:@"point_red.png"];
    [loginBackground addSubview:play_display];

    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(3, 0, 50, 50) text:str];
    
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.numberOfLines = 3;
    NSLog(@"title = %@",str);
    [play_display addSubview:titleLabel];
    
    UILabel *welcomeLabel = [UILabel labelWithFrame:CGRectMake(80, 30, 160, 20) text:@"欢迎来到我的驴妈妈"];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor whiteColor];
    [loginBackground addSubview:welcomeLabel];
    
    UILabel *clickLogin = [UILabel labelWithFrame:CGRectMake(0, 60, 320, 20) text:@"点击登录"];
    clickLogin.font = [UIFont systemFontOfSize:14];
    clickLogin.textAlignment = NSTextAlignmentCenter;
    clickLogin.textColor = [UIColor whiteColor];
    [loginBackground addSubview:clickLogin];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealLogin:)];
    [loginBackground addGestureRecognizer:tap];

}

- (void)dealLogin:(UITapGestureRecognizer *)tap
{
    LoginViewController *lvc = [[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)createNavBar
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *rightBtn = [UIButton imageButtonWithFrame:CGRectMake(self.view.frame.size.width-55, 24, 55, 35) title:@"注册" image:nil background:@"login_register_bg_normal.png" target:self action:@selector(rightBtnClick:)];

    //[rightBtn setBackgroundImage:[UIImage imageNamed:@"map_icon_press.9.png"] forState:UIControlStateSelected];
    [backView addSubview:rightBtn];
    
    UILabel *titlelabel = [UILabel labelWithFrame:CGRectMake(8, 28, 120, 30) text:@"我的驴妈妈"];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont systemFontOfSize:18];
    [backView addSubview:titlelabel];

}
- (void)rightBtnClick:(UIButton *)button
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
