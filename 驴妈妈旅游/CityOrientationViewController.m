//
//  CityOrientationViewController.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "CityOrientationViewController.h"
#import "HomeViewController.h"

#import "cityModel.h"

@interface CityOrientationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    HttpRequest *_httpRequest;
    
    //城市首字母
    NSMutableArray *_keys;
    NSMutableArray *_arrayHotCity;
    
    //索引数据数组
    NSMutableArray *_sectionIndexArray;
    
    //定义段头数组和段尾数组
    NSMutableArray *_sectionHeaderTitleArray;
    
    //为了实现搜索
    UISearchBar *_searchBar;
    //创建用于显示搜索界面的对象
    UISearchDisplayController *_searchDisplayController;
    //保存搜索界面的数组
    NSMutableArray *_searchResultArray;
    

}
@end

@implementation CityOrientationViewController

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
     [[UIApplication sharedApplication] keyWindow].rootViewController.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createNav];
    
    
    
    _dataArray = [[NSMutableArray alloc] init];
    //_arrayHotCity = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
    
    _keys = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    _sectionIndexArray = [[NSMutableArray alloc] initWithArray:_keys];
    
    //设置段头
    _sectionHeaderTitleArray = [[NSMutableArray alloc] init];
    
    
    
    [self startDownload];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //创建搜索条
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.placeholder = @"出发城市";
    _searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    
    UIButton *rightButton = [UIButton imageButtonWithFrame:CGRectMake(270, 10, 10, 20) title:nil image:nil background:@"voice_searchbox_btn" target:self action:@selector(rightBtnClick:)];
    [_searchBar addSubview:rightButton];
    _tableView.tableHeaderView = _searchBar;
    
    //有两种处理搜索的方式:
    //  1.使用系统类处理搜索
    //  2.新建一个界面处理搜索
    //系统UISearchDisPlayController中包含一个tableView
    //      可以用这tableView显示搜索后的数据
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //要给_searchDisplayController提供搜索结果
    
    _searchDisplayController.searchResultsDataSource = self;
    //注意:当搜索框中文本改变时执行搜索
    
    _searchResultArray = [[NSMutableArray alloc] init];
    
    


}

- (void)startDownload
{
    _httpRequest = [[HttpRequest alloc] initWithURLString:@"http://api3g.lvmama.com/clutter/router/rest.do?method=api.com.recommend.getRouteFromDest&udid=355533050871178&osVersion=4.1.1&lvversion=5.3.1&formate=json&secondChannel=ANDROID_360&firstChannel=ANDROID" target:self action:@selector(downloadFinish:)];
}
- (void)downloadFinish:(HttpRequest *)httpRequest
{
    NSMutableDictionary *Citydict = [NSJSONSerialization JSONObjectWithData:httpRequest.downloadData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *datasArray = Citydict[@"datas"];
    char city = 'A';
    for (int i = 0; i<26; i++) {
   
    NSMutableArray *cityArray = [[NSMutableArray alloc]init];
    NSString *cityStr = [NSString stringWithFormat:@"%c",city];
        
    for (NSDictionary *dict in datasArray) {
        
        cityModel *model = [[cityModel alloc] init];
       
        [model setValuesForKeysWithDictionary:dict];
        
        if ([[model.pinyin substringToIndex:1] isEqualToString:cityStr]) {
            
            [cityArray addObject:model];

        }
        
    }
        if (cityArray.count != 0) {
      
        [_dataArray addObject:cityArray];
            
        }
        city ++;
        
    }
    [_tableView reloadData];
    
}

#pragma mark - tableView
//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //传入不是原来的tableview，而是搜索控制器中的
    if (tableView != _tableView) {
        NSLog(@"开始搜索");
        //设置搜索结果只有一组
        return 1;
    }
    
    
    return _dataArray.count;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //这种情况下,肯定搜索控制器中tableView调用这个方法
    //  返回搜索结果的个数
    if (tableView != _tableView) {
        //处理搜索，得到搜索结果的数组
        [_searchResultArray removeAllObjects];
        for (NSArray *subArray in _dataArray) {
            for (cityModel *city in subArray) {
                if ([city.name rangeOfString:_searchBar.text].location != NSNotFound) {
                    [_searchResultArray addObject:city.name];

                }
            }
        }
        
        //返回两个搜索的结果的个数
        return _searchResultArray.count;
    }
    

    
   return  [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"Cell";
    
    // NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID] ;
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if (tableView != _tableView) {
        cell.textLabel.text = _searchResultArray[indexPath.row];
        return cell;
    }
    
    cityModel *model = _dataArray[indexPath.section][indexPath.row];
    
    
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cityModel *model = _dataArray[indexPath.section][indexPath.row];
    HomeViewController *hvc = [[HomeViewController alloc] init];
    
    //hvc.model = model;
    hvc.cityName = model.name;
    hvc.subName = model.subName;
    
    /*
    if (_searchResultArray != nil) {
        hvc.searchCity = _searchBar.text;
    }
     */
    [self.navigationController pushViewController:hvc animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

#pragma mark - 索引
//显示索引
//返回表格视图段的索引数组
//效果:点击索引跳转到对应的组/段
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    bgView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 5, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    //titleLabel.font = [UIFont systemFontOfSize:16];
    
    cityModel *model =  _dataArray[section][0];
    NSString *key = [model.pinyin substringToIndex:1];
    
    titleLabel.text = key;
    [bgView addSubview:titleLabel];
    
    return bgView;
}





- (void)createNav
{
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *fanhuiButton = [UIButton imageButtonWithFrame:CGRectMake(0, 24, 44, 35) title:Nil image:nil background:@"fanhui.9.png" target:self action:@selector(leftBtnClick:)];
    [backView addSubview:fanhuiButton];
    
    
    
}

- (void)leftBtnClick:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)rightBtnClick:(UIButton *)button
{
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end