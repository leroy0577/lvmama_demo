//
//  HomeViewController.m
//  驴妈妈旅游
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "cityModel.h"

#import "CityOrientationViewController.h"
#import "DetailViewController.h"
#import "MyTabBarController.h"

#import "ZBarSDK.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import <CoreLocation/CoreLocation.h>
#import "LocationCenter.h"

#import "LYGifImageView.h"

#define HOMETABLE_URL @"http://m.lvmama.com/cms/index.php?s=/Api/getInfos&channelCode=SY&tagCodes=SY_TJ&stationCode=%@&page=1&pageSize=6&udid=355533050871178&osVersion=4.1.1&lvversion=5.3.1&formate=json&secondChannel=ANDROID_360&firstChannel=ANDROID"
#define HOMESCORLL_URL @"http://m.lvmama.com/cms/index.php?s=/Api/getInfos&channelCode=SY&tagCodes=SY_BANNER&stationCode=%@&udid=355533050871178&osVersion=4.1.1&lvversion=5.3.1&formate=json&secondChannel=ANDROID_360&firstChannel=ANDROID"
#define HOMEYIYUAN_URL @"http://m.lvmama.com/cms/index.php?s=/Api/getInfos&channelCode=SY&tagCodes=SY_ZDYMK&stationCode=%@&udid=355533050871178&osVersion=4.1.1&lvversion=5.3.1&formate=json&secondChannel=ANDROID_360&firstChannel=ANDROID"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ZBarReaderDelegate,MJRefreshBaseViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate  >
{
    HttpRequest *_httpRequest;
    HttpRequest *_httpScrollRequest;
    HttpRequest *_httpRequestYiyuan;
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    UIScrollView *_scrollView;
    NSTimer *_timer;
    UIPageControl *_pageControl;
    
    
    NSInteger _page;
    
    //实现下拉刷新和上拉加载更多
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    
    
    UIView *_headView;
    
    int i;
    int pageNumber;
    
    //NSString *station_code;
    
    //定义定位管理对象
    CLLocationManager *_locationManager;
}
@end

@implementation HomeViewController

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
    
    // 检测网络状态
    [self isNetWorkingConnection];
    
    // 定位服务
    _locationManager = [[CLLocationManager alloc] init];
    //定位后通过代理获取定位信息
    
    _locationManager.delegate = self;
    
    [self startLocation];
    
    self.view.backgroundColor = [UIColor colorWithRed:235/250.0 green:235/250.0 blue:235/250.0 alpha:1];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 345)];
    [self.view addSubview:_headView];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self createNarBar];
    
    [self createHeadView];
    
    [self createTableView];
    
    _headerView = [MJRefreshHeaderView header];
    _headerView.scrollView = _tableView;
    _headerView.delegate = self;
    
    _footerView = [MJRefreshFooterView footer];
    _footerView.scrollView = _tableView;
    _footerView.delegate = self;
    
    [self getStation_code];
}

#pragma mark 判断网络状态
- (void)isNetWorkingConnection
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 0:
                [self isNoConnection];
            case 1:
                NSLog(@"正在使用3G网络");
                break;
            case 2:
                NSLog(@"正在使用wifi网络");
                break;
            default:
                break;
        }
    }];
}

- (void)isNoConnection
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alterView show];
}
#pragma mark 定位
- (void)startLocation
{
    //定位依赖于手机定位模块
    //  定位方式
    //      GPS定位，无线基站，wifi
    
    //定位前一定要检测是否支持定位
    if (![CLLocationManager locationServicesEnabled]) //|| ![CLLocationManager authorizationStatus])
    {
        
        NSLog(@"定位服务不可用或定位服务被禁止");
    }
    
    //开启定位
    //精度有最好，10m，100m，1000m，3000m
    //  根据需求选择精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //当位置变化了10m后通知....
    _locationManager.distanceFilter = 10;
    [_locationManager startUpdatingLocation];
    
    //定位后的数据通过代理获取
    
}
//当定位成功后执行
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"1231231231232132131");
    
    //获取当前位置
    //  当前位置使用CLLocation表示，包含了坐标
    CLLocation *location = manager.location;
    //获取当前坐标(包含经纬度)
    //  CLLocationCoordinate2D表示经纬度坐标
    CLLocationCoordinate2D coordinate = location.coordinate;
    //显示坐标中的经纬度
    NSLog(@"经度 = %f,纬度 = %f ",
          coordinate.longitude,coordinate.latitude);
    //[self.delegate getlongitude:coordinate.longitude latitude:coordinate.latitude];
    
    LocationCenter *dc = [LocationCenter sharedInstans];
    dc.lat = coordinate.latitude;
    dc.lng = coordinate.longitude;
    
    //细节：没有设置distanceFilter之前默认每隔1s定位一次
    //  GPS定位操作是比较耗电的操作
    //  关闭定位
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}


- (void)getStation_code
{
    NSString *stationURL = @"http://m.lvmama.com/cms/index.php?s=/Api/autoStation";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:stationURL parameters:@{@"udid":@"355533050871178",@"osVersion":@"4.1.1",@"lvversion":@"5.3.1",@"formate":@"json",@"secondChannel":@"ANDROID_360",@"firstChannel":@"ANDROID"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //,@"keyword":@"%E5%8C%97%E4%BA%AC"
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *subDict = dict[@"data"];
        NSLog(@"subDict = %@",subDict);
        
        changeModel *model = [[changeModel alloc] init];
        
        [model setValuesForKeysWithDictionary:subDict];
        NSLog(@"%@",model.station_name);
        
        if ([model.station_name isEqualToString:@"上海"]) {
            _station_code = model.station_code;
            
        }
        
        [self startDownloadTableView];
        
        [self createHeadView];
        
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"error = %@",error);
        }];

}
#pragma mark - 处理下拉和上拉的事件
//一旦在下拉刷新和上拉加载的时候都会执行
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //说明是下拉刷新
    if (refreshView == _headerView) {
        //表示要刷新数据
        _page = 1;
        [self startDownloadTableView];
    }
    //说明是上拉加载更多
    if (refreshView == _footerView) {
        _page ++;
        [self startDownloadTableView];
    }
}
#pragma mark - 创建表格视图
- (void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-104) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headView;
    
}

- (void)startDownloadTableView
{
    _httpRequest = [[HttpRequest alloc] initWithURLString:[NSString stringWithFormat:HOMETABLE_URL,_station_code] target:self action:@selector(downloadFinish:)];
   // NSLog(@"httpRequest = %@",_httpRequest);
}

- (void)downloadFinish:(HttpRequest *)httpRequest
{
    //解析输出
    NSDictionary *scorllDict = [NSJSONSerialization JSONObjectWithData:httpRequest.downloadData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *datasArray = scorllDict[@"datas"];
    
    for (NSDictionary *infosDict in datasArray) {
        
        NSArray *infosArray = infosDict[@"infos"];
        
        for (NSDictionary *dict in infosArray) {
           
            infosModel *model = [[infosModel alloc] init];
            
           // NSLog(@"------------------%@",dict);
           // [self createModelFromDictionary:dict className:@"infosModel"];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:model];
            
        }
        
    }
    
    [_headerView endRefreshing];
    [_footerView endRefreshing];
    
    [_tableView reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    infosModel *model = _dataArray[indexPath.section];
    
    
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:model.large_image]];
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.content;
    
    return cell;
}
//处理点击后的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc = [[DetailViewController alloc] init];
    
    [self.navigationController pushViewController:dvc animated:YES];
}
 

#pragma mark - 创建滚动视图
- (void)createHeadView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    
    _scrollView.delegate = self;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [_headView addSubview:_scrollView];

    _httpScrollRequest = [[HttpRequest alloc] initWithURLString:[NSString stringWithFormat:HOMESCORLL_URL,_station_code] target:self action:@selector(scrollViewFinish:)];
    
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * pageNumber, 70);
    NSLog(@"%d",pageNumber);

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *imageArray = @[@"v5_index_ticket_1",@"v5_index_around",@"v5_index_inbound",@"v5_index_outbound",@"v5_index_hotel",@"v5_index_cruise"];
    
    NSArray *titleArray = @[@"景点门票",@"周边游",@"国内游",@"出境游",@"酒店",@"邮轮"];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 , 320, 150)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [_headView addSubview:backView];
    
    UIImageView *hotView = [UIImageView imageViewWithFrame:CGRectMake(70, 10, 25, 15) imageFile:@"v5_index_ticket_hot"];
    [backView addSubview:hotView];
    
    int count = imageArray.count;
    
    for (int j=0; j<count; j++) {
        
        UIButton *button = [UIButton imageButtonWithFrame:CGRectMake(30+j%3*(57+45), 10+j/3*(40+35), 50, 40) title:nil image:nil background:imageArray[j] target:self action:@selector(buttonClick:)];
        
        button.tag = 100+j;
        [backView addSubview:button];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(35+j%3*(57+45), 10+30+j/3*(40+35), 50, 40) text:titleArray[j]];
        
        label.font = [UIFont systemFontOfSize:12];
        [backView addSubview:label];
    }

    _httpRequestYiyuan = [[HttpRequest alloc] initWithURLString:[NSString stringWithFormat:HOMEYIYUAN_URL,_station_code] target:self action:@selector(YiyuanFinish:)];
    NSArray *typeArray = @[@"v5_index_special_price",@"v5_index_goupon"];
    
    for (int j =0; j<2; j++) {
        
        UIButton *typeButton = [UIButton imageButtonWithFrame:CGRectMake(j*(145+10)+10, 290, 145, 50) title:nil image:nil background:typeArray[j] target:self action:@selector(buttonClick:)];
        
        typeButton.tag = 200+j;
        
        [_headView addSubview:typeButton];
    }

    
    
}
- (void)YiyuanFinish:(HttpRequest *)httpRequestYiyuan
{
    
    NSDictionary *scorllDict = [NSJSONSerialization JSONObjectWithData:httpRequestYiyuan.downloadData options:NSJSONReadingMutableContainers error:nil];
    i =0;
    
    infosModel *model = [[infosModel alloc] init];
    
    NSArray *datasArray = scorllDict[@"datas"];
    
    for (NSDictionary *infosDict in datasArray) {
        
        NSArray *infosArray = infosDict[@"infos"];
        
        for (NSDictionary *dict in infosArray) {
            
            [model setValuesForKeysWithDictionary:dict];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:model.large_image]];
            //UIImage *image = [[UIImage alloc] initWithData:data];
            LYGifImageView *image = [[LYGifImageView alloc] initWithGIFData:data];
            image.frame = CGRectMake(i*(145+10)+10 ,230 , 145, 50);
            image.userInteractionEnabled = YES;
            
            if (i == 0) {
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                
                [image addGestureRecognizer:tap1];
            }
            if (i == 1) {
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weekendClick:)];
                
                [image addGestureRecognizer:tap2];
            }
            i++;
             /*
            UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //[typeButton setImage:image forState:UIControlStateNormal];
            
            typeButton.frame = CGRectMake(i*(145+10)+10 ,230 , 145, 50);
            typeButton.tag = 200+i;
            [typeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            i++;
            //[typeButton addSubview:image];
              
            [image addSubview:typeButton];
              */
            [_headView addSubview:image];
            
           
        }
        
    }

}
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"一元门票");
}
- (void)weekendClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"周末出游");
}
#pragma mark - 解析滚动视图的数据
- (void)scrollViewFinish:(HttpRequest *)httpScorllRequest
{
    
    //解析输出
    NSDictionary *scorllDict = [NSJSONSerialization JSONObjectWithData:httpScorllRequest.downloadData options:NSJSONReadingMutableContainers error:nil];
    
    pageNumber = 0;
    infosModel *model = [[infosModel alloc] init];
    
    NSArray *datasArray = scorllDict[@"datas"];
    
        for (NSDictionary *infosDict in datasArray) {
            
            NSArray *infosArray = infosDict[@"infos"];
            
            for (NSDictionary *dict in infosArray) {
                
                //[self createModelFromDictionary:dict className:@"infosModel"];
                [model setValuesForKeysWithDictionary:dict];
        
                UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(pageNumber*self.view.frame.size.width,0, self.view.frame.size.width, 70)];
                
               [backView setImageWithURL:[NSURL URLWithString:model.large_image]];
              
                backView.backgroundColor  = [UIColor blackColor];
                
                pageNumber++;
                
                
                    
                [_scrollView addSubview:backView];
            }
                
        }
    
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dealLoop:) userInfo:_scrollView repeats:YES];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 60, 80, 10)];

        _pageControl.numberOfPages = pageNumber;
    
    
        [_headView addSubview:_pageControl];
        
        [_pageControl addTarget:self action:@selector(dealPageControl:) forControlEvents:UIControlEventValueChanged];
}

- (void)dealPageControl:(UIPageControl *)pc
{
    //根据第几页换算出scrollView中x的坐标
    double x =320 *pc.currentPage;
    
    _scrollView.contentOffset = CGPointMake(x, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)pScrollView
{
    int index = pScrollView.contentOffset.x/320.0;
    _pageControl.currentPage = index;
}
- (void)dealLoop:(NSTimer *)timerLoop
{
    
    static  int j =0;
    _scrollView = (UIScrollView *)_timer.userInfo;
    j = _pageControl.currentPage;
    j++;
    if (j == pageNumber) {
        j = 0;
    }
    _scrollView.contentOffset = CGPointMake(320*j, 0);
    
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
#pragma mark - 创建导航栏
- (void)createNarBar
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *rightButton = [UIButton imageButtonWithFrame:CGRectMake(self.view.bounds.size.width-30, 30, 20, 20) title:nil image:nil background:@"red_qricon.png" target:self action:@selector(rightBtnClick:)];
    [backView addSubview:rightButton];
    
//    UILabel *localeLabel = [UILabel labelWithFrame:CGRectMake(5, 35, 70, 10) text:@"北京出发"];
//    localeLabel.textColor = [UIColor whiteColor];
//    localeLabel.font = [UIFont systemFontOfSize:12];
//    [backView addSubview:localeLabel];
   // _cityName = @"北京";
    if (_searchCity != nil) {
        _cityName = _searchCity;
    }
    UIButton *locale = [UIButton systemoButtonWithFrame:CGRectMake(5, 35, 70, 10) title:[NSString stringWithFormat:@"%@出发",_cityName] target:self action:@selector(leftBtnClick:)];
    [locale.titleLabel setFont:[UIFont systemFontOfSize:12]];
    if (_cityName == nil) {
        _cityName = @"北京";
        [locale setTitle:[NSString stringWithFormat:@"%@出发",_cityName] forState:UIControlStateNormal];
    }
    [locale setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:locale];
    
    UIImageView *titleView = [UIImageView imageViewWithFrame:CGRectMake(85, 30, 200, 20) imageFile:@"holiday_search.9.png"];
    [backView addSubview:titleView];
    
    UIImageView *seachView = [UIImageView imageViewWithFrame:CGRectMake(5, 5, 10, 10) imageFile:@"tickets_list_icon1_search.png"];
    [titleView addSubview:seachView];
    
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(20, 5, 150, 10) text:@"请输入目的地或景点名"];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:titleLabel];

}

- (void)leftBtnClick:(UIButton *)button
{
    CityOrientationViewController *covc = [[CityOrientationViewController alloc] init];
    
    [self.navigationController pushViewController:covc animated:YES];
}
#pragma mark 二维码扫描
- (void)rightBtnClick:(UIButton *)button
{
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最后读取并显示了条形码的图片和内容。*/
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    reader.showsZBarControls = NO;
    //reader.wantsFullScreenLayout = NO;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    [self setOverlayPickerView:reader];
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self.navigationController pushViewController:reader animated:YES];
    
   // [reader release];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    
    for (UIView *temp in [reader.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                [button removeFromSuperview];
                
            }
            
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                
                [toolbar setHidden:YES];
                
                [toolbar removeFromSuperview];
                
            }
            
        }
        
    }
    
    //画中间的基准线
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    
    line.backgroundColor = [UIColor redColor];
    
    [reader.view addSubview:line];
    
//    [line release];
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [reader.view addSubview:backView];
    
    UIButton *leftButton = [UIButton imageButtonWithFrame:CGRectMake(0, 24, 44, 35) title:nil image:nil background:@"fanhui.9.png" target:self action:@selector(dealLeftBtn:)];
    [backView addSubview:leftButton];
    
    UILabel *title = [UILabel labelWithFrame:CGRectMake(50, 30, 100, 24) text:@"扫描二维码"];
    title.textColor = [UIColor whiteColor];
    [backView addSubview:title];
    
    //左侧的view
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    
    leftView.alpha = 0.3;
    
    leftView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:leftView];
    
//    [leftView release];
    
    //右侧的view
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    
    rightView.alpha = 0.3;
    
    rightView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:rightView];
    
//    [rightView release];
    
    //底部view
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    
    downView.alpha = 0.3;
    
    downView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:downView];
//    [downView release];
    
    MyTabBarController *mtbc = (MyTabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    mtbc.myTabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    

    
    //用于取消操作的button
    
    /*
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancelButton.alpha = 0.4;
    
    [cancelButton setFrame:CGRectMake(20, 390, 280, 40)];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];  
    
    [reader.view addSubview:cancelButton];
     */
}

- (void)dealLeftBtn:(id)sender{
    
    MyTabBarController *mtbc = (MyTabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    mtbc.myTabBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
