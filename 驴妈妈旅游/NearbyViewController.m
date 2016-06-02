//
//  NearbyViewController.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "NearbyViewController.h"
#import "JiudianViewController.h"
#import "ZiyouxingViewController.h"
#import "MapViewController.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import "jingdianModel.h"
#import "jingdianCell.h"

#import "LocationCenter.h"

#define JINGDIAN_URL @"http://api3g.lvmama.com/clutter/router/rest.do?method=api.com.search.placeSearch&lvsessionid=&udid=355533050871178&firstChannel=ANDROID&secondChannel=ANDROID_360&lvversion=5.3.1&osVersion=4.1.1&deviceName=GT-I9300&globalLongitude=%f&globalLatitude=%f&formate=json"


@interface NearbyViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_jingdianTabelView;
    NSMutableArray *_dataArray;
    
    
    UIView *_view;
    
    NSInteger _page;
    NSString *_categoryId;
    
    //实现下拉刷新和上拉加载更多
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    
    LocationCenter *dc;
    
    
}
@end

@implementation NearbyViewController

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
    dc = [LocationCenter sharedInstans];
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    _view  = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    [_view setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:_view];
    [self createBtn];
    
    [self createNav];
    _dataArray = [[NSMutableArray alloc] init];

    
    [self jingdianPostRequest];
    
    _jingdianTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-104) style:UITableViewStylePlain];
    _jingdianTabelView.tag = 110;
    _jingdianTabelView.dataSource = self;
    _jingdianTabelView.delegate = self;
    [self.view addSubview:_jingdianTabelView];
    
    _jingdianTabelView.tableHeaderView = _view;
    
    
    _headerView = [MJRefreshHeaderView header];
    _headerView.scrollView = _jingdianTabelView;
    _headerView.delegate = self;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.scrollView = _jingdianTabelView;
    _footerView.delegate = self;
    
}
#pragma mark - 处理下拉和上拉的事件
//一旦在下拉刷新和上拉加载的时候都会执行
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //说明是下拉刷新
    if (refreshView == _headerView) {
        //表示要刷新数据
        _page = 1;
        [self jingdianPostRequest];
    }
    //说明是上拉加载更多
    if (refreshView == _footerView) {
        _page ++;
        [self jingdianPostRequest];
    }
}

- (void)jingdianPostRequest
{
#pragma mark - 景点数据遍历
    NSString *jingdianURL = [NSString stringWithFormat:JINGDIAN_URL,dc.lng,dc.lat];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:jingdianURL parameters:@{@"longitude":@"116.380311",@"latitude":@"40.04308",@"sort":@"juli",@"windage":@"100000",@"page":@"1",@"stage":@"2",@"productType":@"TICKET",@"hasRoute":@"true",@"pageSize":@"20"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *datasArray = dict[@"datas"];
        
        for (NSDictionary *subDict in datasArray) {
            
           // [self createModelFromDictionary:subDict className:@"jingdianModel"];
            jingdianModel *model = [[jingdianModel alloc] init];
            
            [model setValuesForKeysWithDictionary:subDict];
            
            [_dataArray addObject:model];
            
        }
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        
        [_jingdianTabelView reloadData];
        
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
    
    jingdianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[jingdianCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor colorWithRed:235/250.0 green:235/250.0 blue:235/250.0 alpha:1];
    }
    
    jingdianModel *model = _dataArray[indexPath.row];
    
    [cell.absoluteMiddleImage setImageWithURL:[NSURL URLWithString:model.absoluteMiddleImage]];
    cell.nameLabel.text = model.name;
    cell.cmtStartsLabel.text = [NSString stringWithFormat:@"%@分",model.cmtStarts];
    cell.subjectLabel.text = model.subject;
    cell.addressLabel.text = model.address;

    cell.sellPriceYuanLabel.text = [NSString stringWithFormat:@"￥%d起",model.sellPriceYuan.intValue];
    cell.marketPriceYuanLabel.text = [NSString stringWithFormat:@"￥%d",model.marketPriceYuan.intValue];
    cell.juliLabel.text = [NSString stringWithFormat:@"%.1fkm",model.juli.floatValue/1000];
    
    //cell.orderTodayAbleLabel.backgroundColor = nil;
    
    if (model.orderTodayAble) {
        NSLog(@"type = %d",model.orderTodayAble);
        cell.orderTodayAbleLabel.frame = CGRectMake(110, 45, 60, 15);
        cell.orderTodayAbleLabel.text = @"可订今日票";
        cell.orderTodayAbleLabel.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        cell.orderTodayAbleLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    //cell.orderTodayAbleLabel.frame = CGRectMake(0, 0, 0, 0);
    /*
    else
    {
        if (model.orderTodayAble) {
            NSLog(@"type = %d",model.orderTodayAble);
            cell.orderTodayAbleLabel.text = @"可订今日票";
            cell.orderTodayAbleLabel.backgroundColor = [UIColor orangeColor];

        }
        else
        {

        }
    }
     */
    
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
        
        if (i == 0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"actionbar_bg.png"] forState:UIControlStateNormal];
        }
        [_view addSubview:button];
    }
}

-(void)btnClick:(UIButton *)button
{
    if (button.tag == 101) {
        JiudianViewController *jvc = [[JiudianViewController alloc] init];
        
        [self.navigationController pushViewController:jvc animated:NO];
    }
    if (button.tag == 102) {
        ZiyouxingViewController *zvc = [[ZiyouxingViewController alloc] init];
        
        [self.navigationController pushViewController:zvc animated:NO];
    }
}

- (void)createNav
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
    mvc.typeName = @"景点";
    [self.navigationController pushViewController:mvc animated:NO];
    
}
@end
