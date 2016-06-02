//
//  JiudianViewController.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-27.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "JiudianViewController.h"
#import "NearbyViewController.h"
#import "ZiyouxingViewController.h"
#import "MapViewController.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import "JiudianModel.h"
#import "JiudianCell.h"

@interface JiudianViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    
    
    UIView *_view;
}
@end

@implementation JiudianViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    _view  = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    [_view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_view];
    [self createBtn];
    
    [self createNavBar];
    _dataArray = [[NSMutableArray alloc] init];
    
    [self jiudianPostRequest];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _tabelView.tag = 110;
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    [self.view addSubview:_tabelView];
    
    _tabelView.tableHeaderView = _view;
}
- (void)jiudianPostRequest
{
#pragma mark - 酒店数据读取
    NSString *jiudianURL = @"http://api3g2.lvmama.com/api/router/rest.do?method=api.com.search.searchHotel&formate=json&version=1.0.0&lvsessionid=&udid=355533050871178&firstChannel=ANDROID&secondChannel=ANDROID_360&lvversion=5.3.1&osVersion=4.1.1&deviceName=GT-I9300&globalLongitude=116.37596&globalLatitude=40.043035";
    
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager2 POST:jiudianURL parameters:@{@"pLongitude":@"116.375854",@"pLatitude":@"40.043024",@"pRadius":@"20",@"pageIndex":@"1",@"pageSize":@"20"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dataDict = [[NSDictionary alloc] initWithDictionary:dict[@"data"]];
        
        NSArray *hotelList = dataDict[@"hotelList"];
        
        for (NSDictionary *subDict in hotelList) {
            
            //[self createModelFromDictionary:subDict className:@"jiudianModel"];
            JiudianModel *model = [[JiudianModel alloc] init];
            
            [model setValuesForKeysWithDictionary:subDict];
            
            [_dataArray addObject:model];
            
        }
        
        [_tabelView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",error);
    }];
}
#pragma mark - 快速建模
- (void)createModelFromDictionary:(NSDictionary *)dict className:(NSString *)className
{
    printf("\n@interface %s : NSObject\n",className.UTF8String);
    for (NSString *key in dict) {
        printf("@property (copy,nonatomic) NSString * %s;\n",key.UTF8String);
    }
    printf("@end\n");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    JiudianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[JiudianCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor colorWithRed:235/250.0 green:235/250.0 blue:235/250.0 alpha:1];
    }
    
    JiudianModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    //config
    
    
    return cell;
}


- (void)createBtn
{
    
    NSArray *titleArray = @[@"景点",@"酒店",@"自由行"];
    
    for (int i = 0;  i<3 ; i++) {
        float w = 100;
        float h = 30;
        float x = i * 100+10;
        float y = 5;
        
        UIButton *button = [UIButton imageButtonWithFrame:CGRectMake(x, y, w, h) title:titleArray[i] image:nil background:@"tab_nearby_bg.png" target:self action:@selector(btnClick:)];
        [button setTitleColor:[UIColor colorWithRed:209/255.0 green:31/255.0 blue:127/255.0 alpha:1] forState:UIControlStateNormal];
        
        
        button.tag = 100 +i;
        
        if (i == 1) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"actionbar_bg.png"] forState:UIControlStateNormal];
        }
        [_view addSubview:button];
    }
}

-(void)btnClick:(UIButton *)button
{
    if (button.tag == 100) {
        
        NearbyViewController *nvc = [[NearbyViewController alloc] init];
        
        [self.navigationController pushViewController:nvc animated:NO];
    }
    if (button.tag == 102) {
        
        ZiyouxingViewController *zvc = [[ZiyouxingViewController alloc] init];
        
        [self.navigationController pushViewController:zvc animated:NO];
    }
}
- (void)createNavBar
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *rightBtn = [UIButton imageButtonWithFrame:CGRectMake(self.view.frame.size.width-44, 24, 44, 35) title:nil image:nil background:@"map_icon.9.png" target:self action:@selector(rightBtnClick:)];
    
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"map_icon_press.9.png"] forState:UIControlStateSelected];
    [backView addSubview:rightBtn];
    
    UILabel *titlelabel = [UILabel labelWithFrame:CGRectMake(8, 28, 50, 30) text:@"周边"];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont systemFontOfSize:18];
    [backView addSubview:titlelabel];
}
- (void)rightBtnClick:(UIButton *)button
{
    MapViewController *mvc = [[MapViewController alloc] init];
    
    mvc.typeName = @"酒店";
    [self.navigationController pushViewController:mvc animated:NO];
}

@end
