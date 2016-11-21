//
//  GroundMapController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/8/15.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "GroundMapController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

//设备物理尺寸
#define screen_width kWidth
#define screen_height kHeight
#define Myuser [NSUserDefaults standardUserDefaults]


@interface GroundMapController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    BMKPinAnnotationView *newAnnotation;
    
    BMKGeoCodeSearch *_geoCodeSearch;
    
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    
    BMKLocationService *_locService;
    
    NSIndexPath *lastIndexPath;
    
    NSInteger lastIndex;
//    当前经纬度
    CLLocationCoordinate2D loc;
    
    CLLocationManager * _locationManager;
    
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *mapPin;

@property (weak, nonatomic) IBOutlet UITableView *cityTableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableH;

@property(nonatomic,strong)NSMutableArray *cityDataArr;
@end

@implementation GroundMapController

-(NSMutableArray *)cityDataArr {
    if (_cityDataArr==nil) {
        _cityDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _cityDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lastIndex = 0;
    
    self.navigationItem.title = @"地图选址";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(sendWeizhi)];
    
    self.tableH.constant = kScreenHeight - 44 - 200 - 64 -20;
    
    [self initLocationService];
    
    
    //创建CLLocationManager对象
    _locationManager = [[CLLocationManager alloc] init];
    //设置代理为自己
    _locationManager.delegate = self;
    
    [_locationManager startUpdatingLocation];
    
    [self createUI];
}

- (void)createUI {
    UIButton * selectAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAddressBtn.backgroundColor = [UIColor colorWithHexString:@"ff801a"];
    [selectAddressBtn setTitle:@"选择此地址" forState:UIControlStateNormal];
    [selectAddressBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    selectAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAddressBtn addTarget:self action:@selector(selectAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectAddressBtn];
    [selectAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-12);
        make.height.offset(45);
    }];

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = CGRectMake(0, 0, 55, 50);
    [leftButton setImage:[UIImage imageNamed:@"iconfont-login-back-copy"] forState:UIControlStateNormal];
//    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0,-5,0,0);
//    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    leftButton.autoresizesSubviews = YES;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [leftButton addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    KZCityModel*model=self.cityDataArr[indexPath.row];

    if (lastIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = model.name;
    
    cell.detailTextLabel.text = model.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    lastIndex = indexPath.row;
    [self.cityTableview reloadData];
}

#pragma mark 设置cell分割线做对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    if ([self.cityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cityTableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.cityTableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.cityTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 初始化地图，定位
-(void)initLocationService {
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    
    [_mapView bringSubviewToFront:_mapPin];
    
    
    if (_locService==nil) {
        
        _locService = [[BMKLocationService alloc]init];
        
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    _locService.delegate = self;
    [_locService startUserLocationService];

    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];
    
    
    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    loc = MapCoordinate;
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
}

#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    [SVProgressHUD showWithStatus:@"加载中..."];
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        [self.cityDataArr removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            KZCityModel *model=[[KZCityModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            
            [self.cityDataArr addObject:model];
        }
         [self.cityTableview reloadData];
//         [SVProgressHUD dismiss];
    } else {
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    //    在不需要时，通过下边的方法使引用计数减1
    //    [BMKRadarManager releaseRadarManagerInstance];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)selectAddressBtnClick {
    
    if (nil != _cityDataArr) {
        if ([_delegate respondsToSelector:@selector(getCityModel:andWeizhi:)]) {
            [_delegate getCityModel:self.cityDataArr[lastIndex] andWeizhi:loc];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backHandle {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
