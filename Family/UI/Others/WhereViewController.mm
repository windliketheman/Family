//
//  WhereViewController.m
//  ennew
//
//  Created by jzkj on 15/6/25.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "WhereViewController.h"

@interface WhereViewController ()
{
    BMKMapView *_mapView;
    
    BMKLocationService *_locService;
}
@end

@implementation WhereViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBaiDuMapView];
}

//将要出现的时候
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    _mapView.zoomLevel = 18;
}

#pragma mark - Rewrite Super
- (void)customNavigationBar
{
    [self setNavigationBarTitle:@"位置"];
}

#pragma mark - Inner Methods

- (void)createBaiDuMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.zoomLevel = 18;//3-19
    
    //实时路况图层
    [_mapView setTrafficEnabled:NO];

    //设置定位精度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新（米）
    [BMKLocationService setLocationDistanceFilter:800.0f];
    
    
    _mapView.showMapScaleBar = YES;
    _mapView.showsUserLocation = YES;
    
    NSLog(@"精度%f维度%f",self.sendCoordinate.latitude,self.sendCoordinate.longitude);
    
//    self.sendCoordinate = CLLocationCoordinate2D{39.563444,116.781225};
    
    if (self.sendCoordinate.latitude == 0 || self.sendCoordinate.longitude == 0) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        
        //启动定位服务
        [_locService startUserLocationService];
        //显示定位层
        _mapView.showsUserLocation = YES;
    }
    
    //定位圈关闭
    //_mapView.isAccuracyCircleShow
    BMKLocationViewDisplayParam *param =[[BMKLocationViewDisplayParam alloc]init];
    param.isAccuracyCircleShow = false;
    [_mapView updateLocationViewWithParam:param];
    
    _mapView.centerCoordinate = self.sendCoordinate;
    
    //添加标注
    [self addAnnotations];
}

- (void)addAnnotations
{
    if (self.sendCoordinate.latitude != 0 || self.sendCoordinate.longitude != 0) {
        //添加标注
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = self.sendCoordinate;
        [CommonCore isBlankString: self.userNameString]?(annotation.title = @"我在这里"):(annotation.title = self.userNameString);
        [_mapView addAnnotation:annotation];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark BMKLocationServiceDelegate
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //将定位的中心点显示到地图的中心
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

#pragma mark 返回
- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end