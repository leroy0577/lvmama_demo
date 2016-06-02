//
//  MapViewController.m
//  驴妈妈旅游
//
//  Created by luoyang on 14-10-8.
//  Copyright (c) 2014年 luoyang. All rights reserved.
//

#import "MapViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CLLocation+Sino.h"
#import <CoreLocation/CoreLocation.h>
#import "MyTabBarController.h"

#import "LocationCenter.h"

@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate,CLLocationManagerDelegate>
{
    //定义地图对象
    MAMapView *_mapView;
    
    //创建搜索对象
    AMapSearchAPI *_mapSearch;
    
    LocationCenter *dc;
}
@property (retain,nonatomic)AMapSearchAPI *search;

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    MyTabBarController *mtbc = (MyTabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    mtbc.myTabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createNav];
    dc = [LocationCenter sharedInstans];
    
    //高德地图在使用前一定要舒适化APIKey，否则崩溃
    [MAMapServices sharedServices].apiKey = @"8bec732862afb9dbbffe0b34fe533c2c";
    
    //创建高德地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    [self.view addSubview:_mapView];
    
    
    
    //设置地图类型
    _mapView.mapType = MAMapTypeStandard;
    
    //设置是否显示用户位置
    _mapView.showsUserLocation = YES;

    //设置跟随模式
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    //设置地图缩放级别
    _mapView.zoomEnabled = 19;
    
    _mapView.delegate = self;
    //开启/禁止缩放
    _mapView.zoomEnabled = YES;
    
    //设置是否显示罗盘
    _mapView.showsScale = YES;
    
    //地图是否可以旋转
    //_mapView.scrollEnabled = YES;
    
    //设置显示比例尺
    _mapView.scaleOrigin = CGPointMake(0, 0);
    
    //地图是否可以倾斜
    //_mapView.rotateEnabled = YES;
    
    //设置logo位置
    _mapView.logoCenter = CGPointMake(320-44, 460);
    
    //显示大头针
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dealLongPress:)];
//    
//    [_mapView addGestureRecognizer:longPress];
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"8bec732862afb9dbbffe0b34fe533c2c" Delegate:self];
    
    
    [self searchPlaceByAround];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //使用加入复用机制
    static NSString *annotationID = @"Annotation";
    
    
    MAPinAnnotationView *pin = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
    
    if (pin == nil) {
        
        pin = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationID];
    }
    
    //config pin
    pin.canShowCallout = YES;
    pin.animatesDrop = YES;
    
    pin.pinColor = MAPinAnnotationColorRed;
    
    return pin;
    
}
#pragma mark - 周边搜索
- (void)searchPlaceByAround
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:dc.lat longitude:dc.lng];
    poiRequest.keywords = _typeName;
    poiRequest.radius= 10000;
    [self.search AMapPlaceSearch: poiRequest];
    
    NSLog(@"----------------%f",_mapView.userLocation.location.coordinate.latitude);
}
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        
        //添加大头针
        MAPointAnnotation *ann = [[MAPointAnnotation alloc] init];
        ann.title = p.name;
        ann.subtitle = p.address;
        ann.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        [_mapView addAnnotation:ann];
        
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}
- (void)modeAction
{
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
}
/*
- (void)dealLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [longPress locationInView:_mapView];
        
        CLLocationCoordinate2D coordinate2D = [_mapView convertPoint:point toCoordinateFromView:_mapView];
        
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        
        annotation.title = @"dwada";
        annotation.subtitle = @"dgdrg";
        annotation.coordinate = coordinate2D;

        [_mapView addAnnotation:annotation];
    }
    
    
}
 */

-(void)createNav
{
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [backView setImage:[UIImage imageNamed:@"actionbar_bg.png"]];
    backView.userInteractionEnabled = YES;
    
    [self.view addSubview:backView];
    
    UIButton *leftButton = [UIButton imageButtonWithFrame:CGRectMake(0, 24, 44, 35) title:nil image:nil background:@"fanhui.9.png" target:self action:@selector(dealLeftBtn:)];
    [backView addSubview:leftButton];
    
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(50, 30, 100, 24) text:[NSString stringWithFormat:@"周边%@",_typeName]];
    titleLabel.textColor = [UIColor whiteColor];
    [backView addSubview:titleLabel];
    
    
}
- (void)dealLeftBtn:(UIButton *)button
{
    MyTabBarController *mtbc = (MyTabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    mtbc.myTabBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
