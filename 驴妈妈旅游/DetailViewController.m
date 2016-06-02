//
//  DetailViewController.m
//  驴妈妈旅游
//
//  Created by luoyang on 14-10-10.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIActionSheetDelegate>

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createUI];
}
- (void)createUI
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *leftButton = [UIButton imageButtonWithFrame:CGRectMake(0, 24, 40, 35) title:nil image:nil background:@"fanhui.9.png" target:self action:@selector(dealBtn:)];
    leftButton.tag = 300;
    [backView addSubview:leftButton];

    UIButton *shareButton = [UIButton imageButtonWithFrame:CGRectMake(320-40*4, 24, 40, 35) title:nil image:nil background:@"share_press_icon.9.png" target:self action:@selector(dealBtn:)];
    shareButton.tag = 301;
    [backView addSubview:shareButton];
    
    UIButton *loveButton = [UIButton imageButtonWithFrame:CGRectMake(320-40*3, 24, 40, 35) title:nil image:nil background:@"star_icon.9.png" target:self action:@selector(dealBtn:)];
    loveButton.tag = 302;
    [backView addSubview:loveButton];
    
    UIButton *phoneButton = [UIButton imageButtonWithFrame:CGRectMake(320-40*2, 24, 40, 35) title:nil image:nil background:@"tel_icon.9.png" target:self action:@selector(dealBtn:)];
    phoneButton.tag = 303;
    [backView addSubview:phoneButton];
    
    UIButton *homeButton = [UIButton imageButtonWithFrame:CGRectMake(320-40, 24, 40, 35) title:nil image:nil background:@"home_back_normal.9.png" target:self action:@selector(dealBtn:)];
    homeButton.tag = 304;
    [backView addSubview:homeButton];
}

- (void)dealBtn:(UIButton *)button
{
    if (button.tag == 300) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == 301) {
        NSLog(@"ddwadaw");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"微信好友",@"微信朋友圈", nil];
        [actionSheet showInView:self.view];

        
    }
    if (button.tag == 302) {
        
    }
    if (button.tag == 303) {
        
    }
    if (button.tag == 304) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
/*
#pragma mark - 处理各种分享
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //buttonIndex 0~2
    if (buttonIndex < 3) {
        
        //定义了分享的平台(途径)
        NSArray *sharePlatform = @[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline];
        
        NSString *shareText = @"最近发现这个酒店或景点不错";
        
        //设置分享内容和回调对象
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:nil];
        
        //根据点击了不同的按钮实现
        [UMSocialSnsPlatformManager getSocialPlatformWithName:sharePlatform[buttonIndex]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}
 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
