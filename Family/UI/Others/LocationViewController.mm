//
//  ViewController.m
//  location
//
//  Created by tianlinchun on 15/6/8.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "LocationViewController.h"
#import "CommonData.h"

#define ImgView_W 100
#define headImgView_W 30

@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BMKMapView *_mapView;//地图
    BMKPointAnnotation *_annotation;
    BMKLocationService *_locService;//定位服务
    BMKPoiSearch *_POisearcher;//地理详情（周边详情）
    BMKGeoCodeSearch *_geocodeSearch;//地理编码检索对象
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
    
    //创建tableView展示
    UITableView *_myTableView;
    
    //tableView的数据源
    NSMutableArray *_dataArray;
    
    //开始定位按钮
    UIButton *startButton;
    
    //位置信息
    NSString *_addressStr;
    //经纬度
    CLLocationCoordinate2D _coodinate;
    NSString *_name;
    
    UIImageView *imgView;//头像图像的底层
    UIImageView *headImgView;//头像
    
    NSString *server_URL;
    
    //头部视图
    UIView *headView;
    UILabel *myLocationLabel;//我的位置
    UILabel *myAdressLabel;//我的详细地址
    UIImageView *markImgView;//标记图标
    NSInteger indec;
}
@end

@implementation LocationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //数组初始化
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        
        _geocodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geocodeSearch.delegate = self;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //服务器地址
    server_URL = [CommonData serverURL];
    
    [self createMapView];
    [self createUserHeadImgView];
    [self createReStateLoctionButton];
    [self createTableView];
}

//将要出现的时候
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 设置背景色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _POisearcher.delegate = self;
    _geocodeSearch.delegate = self;
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    _mapView.zoomLevel = 18;
    
}

////将要消失的时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _POisearcher.delegate = nil;
    _geocodeSearch.delegate = nil;
    
    [_locService stopUserLocationService];
}

#pragma mark - Rewrite Super
- (void)customNavigationBar
{
    [self setNavigationBarTitle:@"位置"];
    
    [self addNavigationBarRightButtonItemWithTitle:@"发送" color:[UIColor redColor] action:@selector(sendOnClick)];
}

#pragma mark - Inner Methods
- (void)createMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height/2)];
    
    [_mapView setMapType:BMKMapTypeStandard];//设置地图显示类型
    [_mapView setZoomLevel:18];              //设置地图放大等级
    [_mapView setTrafficEnabled:NO];         //实时路况图层
    [BMKLocationService setLocationDistanceFilter:1000.0f];//指定最小距离更新（米）
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyHundredMeters];//设置定位精度
    
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    
    [_locService startUserLocationService];//启动定位服务
    _mapView.showsUserLocation = YES;//显示用户的位置
    
    //定位圈关闭
    //_mapView.isAccuracyCircleShow
    BMKLocationViewDisplayParam *param =[[BMKLocationViewDisplayParam alloc]init];
    param.isAccuracyCircleShow = false;
    [_mapView updateLocationViewWithParam:param];
}

- (void)createReStateLoctionButton
{
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(10, Main_Screen_Height/2 - 60, 40, 40);
    startButton.layer.cornerRadius = 4;
    startButton.layer.masksToBounds = YES;
    [startButton setImage:[UIImage imageNamed:@"locatie_normal.png"] forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"locatie_pressed.png"] forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(startButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}

#pragma mark -- 创建用户头像显示(Imgview需要先创建_mapView)
- (void)createUserHeadImgView
{
    if (!imgView)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_mapView.center.x-ImgView_W/2, _mapView.center.y-ImgView_W*3/4, ImgView_W, ImgView_W)];
    }
    
    imgView.image = [UIImage imageNamed:@"bao_safe.png"];
    [self.view addSubview:imgView];
    
    if (!headImgView)
    {
        headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ImgView_W/2 - headImgView_W/2,ImgView_W/2 - headImgView_W/2, headImgView_W, headImgView_W)];
        headImgView.layer.cornerRadius = headImgView_W / 2;
        headImgView.layer.masksToBounds = YES;
    }
    
    if (_img != nil)
    {
        headImgView.image = _img;
    }
    else
    {
        [headImgView sd_setImageWithURL:[NSURL URLWithString:[CommonData userAvatarURL]] placeholderImage:[UIImage imageNamed:@"img_header_a"]];
    }
    
    [imgView addSubview:headImgView];
}

#pragma mark -- 创建tableView
- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height/2, Main_Screen_Width, Main_Screen_Height/2) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}

#pragma mark 导航栏按钮
- (void)sendOnClick
{
    //_mapView.takeSnapshot
    [self.passDelegate postMapViewSnapshot:_mapView.takeSnapshot withMyPlace:_name withMyPlaceJW:_coodinate];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 定位
- (void)startButtonOnClick
{
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
    
    if (_annotation!= nil)
    {
        [_mapView removeAnnotation:_annotation];
    }
    
    _annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    _annotation.title = @"当前位置";
    [_mapView addAnnotation:_annotation];
    
    //将定位的中心点显示到地图的中心
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    //调用反向地理编码
    [self initReverseGeoCode:coor];
}
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

#pragma mark - 发起反向编码
- (void)initReverseGeoCode:(CLLocationCoordinate2D)coordinate
{
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){coordinate.latitude, coordinate.longitude};
    
    if (!reverseGeoCodeSearchOption)
    {
        reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
    if (flag)
    {
        //NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - 接受反向编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在这里处理正常的结果
        [_dataArray removeAllObjects];
        _dataArray = [NSMutableArray arrayWithArray:result.poiList];
        
        BMKPoiInfo *info = _dataArray[0];
        _name = info.name;
        _addressStr = result.address;
        _coodinate = result.location;
        
        NSInteger num = -1;
        for (int i = 0; i < _dataArray.count; i ++) {
            BMKPoiInfo *info = _dataArray[i];
            if ([_name isEqualToString:info.name]) {
                num = i;
                break;
            }
        }
        if (num != -1) {
            [_dataArray removeObjectAtIndex:num];
        }
        
        [_myTableView reloadData];
    }else{
        [self promptMessage:@"抱歉，未找到结果"];
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - BMKMapViewDelegate
//mapView滑动的时候调用
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"地图的位置已经移动");
    CLLocationCoordinate2D coor = [_mapView convertPoint:_mapView.center toCoordinateFromView:imgView];
    [self initReverseGeoCode:coor];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    BMKPoiInfo *info = _dataArray[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.address;
    cell.tag = 100 + indexPath.item;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    
    myLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, Main_Screen_Width - 60, 20)];
    myLocationLabel.text = @"[我的位置]";
    [myLocationLabel setFont:[UIFont systemFontOfSize:15]];
    [headView addSubview:myLocationLabel];
    
    myAdressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, Main_Screen_Width - 60, 20)];
    myAdressLabel.text = _name;
    [myAdressLabel setTextColor:[UIColor redColor]];
    [myAdressLabel setFont:[UIFont systemFontOfSize:11]];
    [headView addSubview:myAdressLabel];
    
    markImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width - 40, 15, 20, 20)];
    [markImgView setImage:[UIImage imageNamed:@"homeland_publish_lookable_checked"]];
    [headView addSubview:markImgView];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = _dataArray[indexPath.row];
    BMKPoiInfo *info1 = [[BMKPoiInfo alloc] init];
    
    info1.name = _name;
    info1.address = _addressStr;
    info1.pt = _coodinate;
    
    _name = info.name;
    _addressStr = info.address;
    _coodinate  = info.pt;
    
    myAdressLabel.text = _name;
    
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:info1];
    _mapView.centerCoordinate = info.pt;
    
    [_myTableView reloadData];
    NSIndexPath *indPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_myTableView scrollToRowAtIndexPath:indPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

//- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;
#pragma mark - 周边检索
//初始化检索对象
- (void)initSearchWithNear:(CLLocationCoordinate2D)coordinate keyWord:(NSString *)word page:(int)index
{
    if (!_POisearcher) {
        _POisearcher = [[BMKPoiSearch alloc] init];
    }
    _POisearcher.delegate = self;
    
    //发起反地理编码
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageIndex = index;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2D{coordinate.latitude,coordinate.longitude};
    option.keyword = word;
    BOOL flag = [_POisearcher poiSearchNearBy:option];
    if (flag) {
        NSLog(@"周边检索发送成功");
    }else{
        NSLog(@"周边检索发送失败");
    }
}

//周边搜索回调
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
