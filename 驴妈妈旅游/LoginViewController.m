//
//  LoginViewController.m
//  驴妈妈旅游
//
//  Created by luoyang on 14-10-13.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "LoginViewController.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"


@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    
    NSDictionary *dict;
}
@end

@implementation LoginViewController

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
    MyTabBarController *mtbc = (MyTabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    mtbc.myTabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createUI];
}
- (void)createUI
{
    
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    [self.view addSubview:backImageView];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *leftButton = [UIButton imageButtonWithFrame:CGRectMake(0, 24, 44, 35) title:nil image:nil background:@"fanhui.9.png" target:self action:@selector(dealLeftBtn:)];
    [backView addSubview:leftButton];
    
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(50, 30, 100, 24) text:@"会员登录"];
    titleLabel.textColor = [UIColor whiteColor];
    [backView addSubview:titleLabel];
    
    
    
    usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 280, 45)];
    usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    usernameTextField.font = [UIFont systemFontOfSize:18];
    usernameTextField.textColor = [UIColor redColor];
    usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    usernameTextField.placeholder = @"请输入邮箱/手机号/用户名";
    if ([self isEmpty:self.username]==NO)
    {
        usernameTextField.text = self.username;
        NSLog(@"<-------------->%@",self.username);
    }
    usernameTextField.delegate = self;
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 20)];
    headView.image = [UIImage imageNamed:@"密码加锁@2x.png"];
    
    usernameTextField.leftView = headView;
    usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self.view addSubview:usernameTextField];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 145, 280, 45)];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.font = [UIFont systemFontOfSize:18];
    passwordTextField.textColor = [UIColor redColor];
    
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    passwordTextField.placeholder = @"请输入密码";
    
    passwordTextField.delegate = self;
    
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    passwordTextField.secureTextEntry = YES;
    
    [self.view addSubview:passwordTextField];
    
    UIButton *loginButtn = [UIButton imageButtonWithFrame:CGRectMake(80, 200, 150, 40) title:@"登录" image:Nil background:@"actionbar_bg.png" target:self action:@selector(loginBtn:)];
    [self.view addSubview:loginButtn];
    
}
- (void)loginBtn:(UIButton *)button
{
    if ([self isEmpty:usernameTextField.text]==YES)
    {
        UIAlertView * alertView = [[UIAlertView alloc]init];
        alertView.message = @"请输入用户名";
        [alertView addButtonWithTitle:@"取消"];
        [alertView show];
        return;
    }
    if ([self isEmpty:passwordTextField.text]==YES)
    {
        UIAlertView * alertView = [[UIAlertView alloc]init];
        alertView.message = @"请输入密码";
        [alertView addButtonWithTitle:@"取消"];
        [alertView show];
        return;
    }
    NSString * urlString = @"http://api3g.lvmama.com/clutter/client/getSessionId.do?lvsessionid=&udid=355533050871178&firstChannel=ANDROID&secondChannel=ANDROID_360&lvversion=5.3.1&osVersion=4.1.1&deviceName=GT-I9300&globalLongitude=116.376318&globalLatitude=40.043333";
    //NSLog(@"------->%@",usernameTextField.text);
    //NSLog(@"------->%@",passwordTextField.text);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict = %@",dict);
        
        [self userInfoHttpRequest];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登录失败");
        
        UIAlertView * alertView = [[UIAlertView alloc]init];
        alertView.message = @"登录失败，请检查网络";
        [alertView addButtonWithTitle:@"取消"];
        [alertView show];
    }];
    
}

- (void)userInfoHttpRequest
{
        NSDictionary *subData = dict[@"data"];
        
        NSString *lvsessionid = [NSString stringWithFormat:@"%@",subData[@"lvsessionid"]];
        NSLog(@"aa----------%@",dict[@"data"]);
    
        NSString *url = [NSString stringWithFormat:@"http://api3g.lvmama.com/clutter/client/login.do?lvsessionid=%@&udid=355533050871178&firstChannel=ANDROID&secondChannel=ANDROID_360&lvversion=5.3.1&osVersion=4.1.1&deviceName=GT-I9300&globalLongitude=116.376318&globalLatitude=40.043333",lvsessionid];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //,@"sign":@"769504f87d564d0b3ab048877dd390fe"
    
        [manager POST:url parameters:@{@"userName":usernameTextField.text,@"password":passwordTextField.text,@"sign":@"769504f87d564d0b3ab048877dd390fe"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *personDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"username = %@",usernameTextField.text);
            NSLog(@"password = %@",passwordTextField.text);
            NSLog(@"abc-------------------------fesf");
            
            NSLog(@"code = %@",personDict[@"code"]);
            
            NSLog(@"personDict = %@",personDict);
            
            if ([personDict[@"code"] isEqualToString:@"-1"]) {
                
                UIAlertView * alertView = [[UIAlertView alloc]init];
                alertView.message = @"帐户或密码错误";
                [alertView addButtonWithTitle:@"取消"];
                [alertView show];
                return;
                
            }
            else
            {
                NSLog(@"personDict = %@",personDict);
            }
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"错误");
        }];
    

}


-(void)backimageClick:(UITapGestureRecognizer *)tap
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void)dealLeftBtn:(UIButton *)button
{
    MyTabBarController *mtbc = (MyTabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    mtbc.myTabBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -判断输入是否为空
-(BOOL)isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
