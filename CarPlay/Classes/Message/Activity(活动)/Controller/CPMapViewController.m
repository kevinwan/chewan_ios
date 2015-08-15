//
//  CPMapViewController.m
//  CarPlay
//
//  Created by chewan on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMapViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import <AMapSearchKit/AMapSearchObj.h>
#import "ZYSearchBar.h"
#import "CPLocationModel.h"
#import <AMap2DMap/MAMapKit.h>
#import "GeocodeAnnotation.h"
#import "CommonUtility.h"
#import "CPMapSearchViewController.h"
#import "CPAnnotationView.h"
#import "CPMapPlaceSearchRequest.h"

@interface CPMapViewController ()<UITextFieldDelegate,AMapSearchDelegate,MAMapViewDelegate, UIGestureRecognizerDelegate>
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;

@property (nonatomic, weak) ZYSearchBar *searchBar;
@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, assign) BOOL orientationSuccess;
@property (nonatomic, strong) MAUserLocation *userLocation;
@property (nonatomic, strong) CPLocationModel *selectLocation;
@property (nonatomic, strong) UIView *descLocationView;
@property (nonatomic, strong) AMapSearchAPI *searchApi;
@property (nonatomic, strong) AMapTip *selectTip;
@property (nonatomic, assign) BOOL isReturn;
@property (nonatomic, copy) NSString *selectName;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) GeocodeAnnotation *lastAnnotation;
@end

@implementation CPMapViewController

- (AMapSearchAPI *)searchApi
{
    if (_searchApi == nil) {
        _searchApi = [[AMapSearchAPI alloc] initWithSearchKey:GaoDeAppKey Delegate:self];
    }
    return _searchApi;
}

- (UIView *)descLocationView
{
    if (_descLocationView == nil) {
        _descLocationView = [[UIView alloc] init];
        _descLocationView.backgroundColor = [UIColor whiteColor];
        _descLocationView.layer.borderColor = [Tools getColor:@"aab2bd"].CGColor;
        _descLocationView.layer.cornerRadius = 3;
        _descLocationView.clipsToBounds = YES;
        _descLocationView.layer.borderWidth = 0.5;
        _descLocationView.x = 10;
        _descLocationView.width = kScreenWidth - 20;
        _descLocationView.height = 66;
        _descLocationView.y = kScreenHeight - 76;
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"选定" forState:UIControlStateNormal];
        [button setBackgroundColor:[Tools getColor:@"fc6e51"]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.width = 50;
        button.height = 30;
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        button.centerY = _descLocationView.centerYInSelf;
        button.x = _descLocationView.width - 60;
        [_descLocationView addSubview:button];
        [button addTarget:self action:@selector(goThere) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = [Tools getColor:@"434a54"];
        name.tag = 3;
        name.frame = CGRectMake(10, 10,button.x - 20, 20);
        [_descLocationView addSubview:name];
        
        UILabel *address = [[UILabel alloc] init];
        address.font = [UIFont systemFontOfSize:12];
        address.textColor = [Tools getColor:@"aab2bd"];
        address.tag = 4;
        address.height = 20;
        address.width = name.width;
        address.y = _descLocationView.height - 30;
        address.x = 10;
        [_descLocationView addSubview:address];
        
        [self.view addSubview:_descLocationView];
        
    }
    return _descLocationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择活动地点";
    self.view.backgroundColor = [UIColor whiteColor];
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.zoomLevel = 17;
    _mapView.delegate = self;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    [self.view addSubview:_mapView];

    [self setUpSubView];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    mTap.delegate = self;
    [self.mapView addGestureRecognizer:mTap];
    
    // 如果有值意味着修改位置 需要显示上一次的位置
    if (self.forValue) {
        CPLocationModel *model = (CPLocationModel *)self.forValue;
        GeocodeAnnotation *annotation = [[GeocodeAnnotation alloc] init];
        annotation.icon = @"定位蓝";
        annotation.coordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
        annotation.title = model.location;
        annotation.subtitle = model.address;
        self.selectName = model.location;
        self.searchBar.placeholder = model.location;
        CLLocationCoordinate2D center = annotation.coordinate;
        
        // 设置显示区域
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:center animated:YES];
        [self setToolBarViewWithAnnotation:annotation];
    }
}

/**
 *  初始化子控件
 */
- (void)setUpSubView
{
    
    ZYSearchBar *searchBar = [[ZYSearchBar alloc] init];
    searchBar.textColor = [Tools getColor:@"aab2bd"];
    searchBar.placeholder = @"请输入目的地";
    searchBar.frame = CGRectMake(40, 2, kScreenWidth - 50, 35);
    [self.navigationController.navigationBar addSubview:searchBar];
    searchBar.delegate = self;
    self.searchBar = searchBar;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.userLocation = userLocation;
        if (self.orientationSuccess == NO && self.forValue== nil) {
//            [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
//            GeocodeAnnotation *userAnno = [[GeocodeAnnotation alloc] init];
//            userAnno.coordinate = userLocation.coordinate;
//            // 利用反地理编码获取位置之后设置标题
//            [SVProgressHUD showWithStatus:@"加载中"];
//            
//            //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
            CPMapPlaceSearchRequest *poiRequest = [[CPMapPlaceSearchRequest alloc] init];
            poiRequest.searchType = AMapSearchType_PlaceAround;
            poiRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            poiRequest.userRequest = YES;
            // types属性表示限定搜索POI的类别，默认为：餐饮服务、商务住宅、生活服务
            // POI的类型共分为20种大类别，分别为：
            // 汽车服务、汽车销售、汽车维修、摩托车服务、餐饮服务、购物服务、生活服务、体育休闲服务、
            // 医疗保健服务、住宿服务、风景名胜、商务住宅、政府机构及社会团体、科教文化服务、
            // 交通设施服务、金融保险服务、公司企业、道路附属设施、地名地址信息、公共设施
            poiRequest.requireExtension = YES;
            
            //发起POI搜索
            [self.searchApi AMapPlaceSearch: poiRequest];

//            
//            userAnno.title = @"我的位置";
//            
//            NSLog(@"%@",userLocation.subtitle);
//            
//            if (userAnno.subtitle.length) {
//                userAnno.subtitle = userLocation.subtitle;
//            }else{
//                userAnno.subtitle = @"未知";
//            }
//            self.orientationSuccess = YES;
        }
    }
}
#pragma mark - 处理按钮点击

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    [self.searchBar resignFirstResponder];
    
//    if (gestureRecognizer.view == self.mapView) {
//        self.descLocationView.hidden = YES;
//    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    for (GeocodeAnnotation *annotation in self.mapView.annotations) {
       MAAnnotationView *view = [self.mapView viewForAnnotation:annotation];
        CGRect annitationRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (CGRectContainsPoint(annitationRect, touchPoint)) {
            return;
//            GeocodeAnnotation *anno = (GeocodeAnnotation *)view.annotation;
//            anno.icon = @"定位";
//            
//            if (anno != self.lastAnnotation) {
//                self.lastAnnotation.icon = @"定位蓝";
//                [self.mapView removeAnnotation:self.lastAnnotation];
//                [self.mapView addAnnotation:self.lastAnnotation];
//                
//                [self.mapView addAnnotation:anno];
//                [self.mapView removeAnnotation:anno];
//                [self.mapView addAnnotation:anno];
//                self.lastAnnotation = anno;
//            }
//            
//            
//            [self setToolBarViewWithAnnotation:anno];
      
        }
    }
    
    // 利用反地理编码获取位置之后设置标题
    [SVProgressHUD showWithStatus:@"加载中"];
    
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    CPMapPlaceSearchRequest *poiRequest = [[CPMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    // types属性表示限定搜索POI的类别，默认为：餐饮服务、商务住宅、生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务、汽车销售、汽车维修、摩托车服务、餐饮服务、购物服务、生活服务、体育休闲服务、
    // 医疗保健服务、住宿服务、风景名胜、商务住宅、政府机构及社会团体、科教文化服务、
    // 交通设施服务、金融保险服务、公司企业、道路附属设施、地名地址信息、公共设施
    poiRequest.requireExtension = YES;
    
    //发起POI搜索
    [self.searchApi AMapPlaceSearch: poiRequest];

}

/**
 *  实现POI搜索对应的回调函数
 *
 *  @param request  request description
 *  @param response response description
 */
- (void)onPlaceSearchDone:(CPMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        [self showInfo:@"没有搜索到符合条件的地点"];
        return;
    }
    if (request.location) { // 点击空白区域时触发
        
        [SVProgressHUD dismiss];
        
        if (request.userRequest && !self.orientationSuccess) {
            self.orientationSuccess = YES;
            CPLocationModel *model = [[CPLocationModel alloc] init];
            
            AMapPOI *poi = [response.pois firstObject];
            
            model.location = poi.name;
            model.latitude = @(poi.location.latitude);
            model.longitude = @(poi.location.longitude);
            model.city = poi.city;
            model.district = poi.district;
            
            if ([poi.province isEqualToString:poi.city]){
                model.address = [NSString stringWithFormat:@"%@%@%@",poi.city, poi.district,poi.name];
            }else{
                model.address = [NSString stringWithFormat:@"%@%@%@%@",poi.province, poi.city, poi.district,poi.name];
            }
            
            if (model.city.length == 0) {
                model.city = poi.province;
            }

            self.userLocation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            self.userLocation.title = model.location;
            self.userLocation.subtitle = model.address;
            [self.mapView setCenterCoordinate:self.userLocation.coordinate animated:YES];
            
            [self setToolBarViewWithModel:model];
            
            DLog(@"laile ");
            
        }else{
            [self setToolBarViewWithMapPlaceSearchResponse:response];
        }
        
    }else{
        DLog(@"wocao");
        // 多个搜索结果
        [self showInfo:[NSString stringWithFormat:@"共找到%zd条符合条件的地点",response.pois.count]];
        self.descLocationView.hidden = YES;
        
        NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
        
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *poi, NSUInteger idx, BOOL *stop) {
            
            GeocodeAnnotation *annotation = [[GeocodeAnnotation alloc] init];
            annotation.icon = @"定位蓝";
            annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            annotation.title = poi.name;
            
            if ([poi.city isEqualToString:poi.province]) {
                annotation.subtitle = [NSString stringWithFormat:@"%@%@%@",poi.city,poi.district,poi.address];
            }else{
                 annotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@",poi.province, poi.city,poi.district,poi.address];
            }

            [poiAnnotations addObject:annotation];
            
        }];
        
        /* 将结果以annotation的形式加载到地图上. */
        [self.mapView addAnnotations:poiAnnotations];
        
        /* 如果只有一个结果，设置其为中心点. */
        if (poiAnnotations.count == 1)
        {
            self.mapView.centerCoordinate = [poiAnnotations[0] coordinate];
        }
        /* 如果有多个结果, 设置地图使所有的annotation都可见. */
        else
        {
            [self.mapView showAnnotations:poiAnnotations animated:YES];
        }

    }
    
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    [self showError:@"加载失败"];
}

- (void)removeAnnotaionNoSelf
{
    for (GeocodeAnnotation *anno in self.mapView.annotations){
        if ([anno isKindOfClass:[GeocodeAnnotation class]]) {
            [self.mapView removeAnnotation:anno];
        }
    }
    self.lastAnnotation = nil;
}

- (void)inputTextDidChange:(ZYSearchBar *)searchBar{
    if (self.descLocationView.hidden == NO) {
        self.descLocationView.hidden = YES;
    }
    if (searchBar.text.length) {
        if (self.resultTableView.hidden == YES) {
            self.resultTableView.hidden = NO;
        }
        [self searchTipsWithKey:searchBar.text];
    }else{
        self.resultTableView.hidden = YES;
    }
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma  mark - UISearchBarDelegate

- (void)clearAndSearchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    /* 清除annotation. */
    [self removeAnnotaionNoSelf];
    
    [self searchGeocodeWithKey:key adcode:adcode];
}

- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    if (adcode.length > 0)
    {
        geo.city = @[adcode];
    }
    [self showLoading];
    [self.searchApi AMapGeocodeSearch:geo];
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.searchApi AMapInputTipsSearch:tips];
}

/**
 * 地理编码回调
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    [SVProgressHUD dismiss];
    if (response.geocodes.count == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"没有搜索到符合条件的地点"];
        return;
    }
    
    if (self.isReturn) { // 如果需要返回
        
        AMapGeocode *gecode = [response.geocodes firstObject];
        
        CPLocationModel *model = [[CPLocationModel alloc] init];
        model.latitude = @(gecode.location.latitude);
        model.longitude = @(gecode.location.longitude);
        model.location = self.selectName;
        
        if (model.location.length == 0) {
            model.location = gecode.building;
        }
        if (model.location.length == 0) {
            model.location = gecode.neighborhood;
        }
        if (model.location.length == 0) {
            model.location = gecode.township;
        }
        model.district = gecode.district;
        model.province = gecode.province;
        model.city = gecode.city;
        model.address = gecode.formattedAddress;
        if (model.city.length == 0) {
            model.city = gecode.province;
        }
        
        if (self.completion) {
            self.completion(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        // 不需要返回的请求
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:response.geocodes.firstObject];
        geocodeAnnotation.title = self.selectName;
        geocodeAnnotation.icon = @"定位蓝";
        [self.mapView addAnnotation:geocodeAnnotation];
        
        [self.mapView setCenterCoordinate:geocodeAnnotation.coordinate animated:YES];
        [self setToolBarViewWithAnnotation:geocodeAnnotation];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CPAnnotationView *annotationView = (CPAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CPAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
            annotationView.canShowCallout = YES;
            
        }
        annotationView.image = [UIImage imageNamed:@"定位蓝"];
        
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

#pragma mark - tableViewDelegate
/**
 *  设置根据annotation模型设置底部的工具栏
 *
 *  @param model
 */
- (void)setToolBarViewWithMapPlaceSearchResponse:(AMapPlaceSearchResponse *)reGeocode
{
    
    CPLocationModel *model = [[CPLocationModel alloc] init];
    
    AMapPOI *poi = [reGeocode.pois firstObject];
    
    model.location = poi.name;
    model.latitude = @(poi.location.latitude);
    model.longitude = @(poi.location.longitude);
    model.city = poi.city;
    model.district = poi.district;
    
    if ([poi.province isEqualToString:poi.city]){
        model.address = [NSString stringWithFormat:@"%@%@%@",poi.city, poi.district,poi.name];
    }else{
        model.address = [NSString stringWithFormat:@"%@%@%@%@",poi.province, poi.city, poi.district,poi.name];
    }

    if (model.city.length == 0) {
        model.city = poi.province;
    }
    
    [self removeAnnotaionNoSelf];
    GeocodeAnnotation *annotation = [[GeocodeAnnotation alloc] init];
    annotation.icon = @"定位蓝";
    annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    annotation.title = model.location;
    annotation.subtitle = model.address;
    [self.mapView addAnnotation:annotation];
    
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    
    [self setToolBarViewWithModel:model];
    
}

/**
 *  设置根据annotation模型设置底部的工具栏
 *
 *  @param model
 */
- (void)setToolBarViewWithAnnotation:(GeocodeAnnotation *)annotation
{
    CPLocationModel *model = [[CPLocationModel alloc] init];
    model.latitude = @(annotation.coordinate.latitude);
    model.longitude = @(annotation.coordinate.longitude);
    model.address = annotation.subtitle;
    model.location = annotation.title;
    [self setToolBarViewWithModel:model];
}

/**
 *  设置根据CPLocationModel模型设置底部的工具栏
 *
 *  @param model
 */
- (void)setToolBarViewWithModel:(CPLocationModel *)model
{
    self.selectLocation = model;
    
    self.descLocationView.hidden = NO;
    
    UILabel *nameLabel = (UILabel *)[self.descLocationView viewWithTag:3];
    nameLabel.text = model.location;
    self.searchBar.text = model.location;
    self.searchBar.placeholder = model.location;
    self.selectName = model.location;
    
    UILabel *addressLabel = (UILabel *)[self.descLocationView viewWithTag:4];
    addressLabel.text = model.address;
}

- (void)goThere
{
    if (self.completion) {
        self.completion(self.selectLocation);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchBar.hidden = YES;
    [SVProgressHUD dismiss];
}

/**
 *  当缩放过大时,返回原来的缩放比例
 *
 *  @param mapView  mapView description
 *  @param animated
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (mapView.zoomLevel > 18.8) {
        [mapView setZoomLevel:18.8 animated:YES];
    }
}

/**
 *  点击搜索框会触发
 *
 *  @param textField textField description
 *
 *  @return return value description
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CPMapSearchViewController *vc = [[CPMapSearchViewController alloc] init];
    if (self.selectName.length) {
        vc.forValue = self.selectName;
    }
    
    __weak typeof(self) weakSelf = self;
    vc.search = ^(NSString *searchText){
        if (searchText.length) {
            
            AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
            
            request.searchType          = AMapSearchType_PlaceKeyword;
            request.keywords            = searchText;
            request.requireExtension    = YES;
            [self showLoading];
            [weakSelf.searchApi AMapPlaceSearch:request];
        }
    };
    
    vc.look = ^(AMapTip *tip){

            weakSelf.selectName = tip.name;
            NSString *key = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
        DLog(@"%@",tip.name);
            [weakSelf clearAndSearchGeocodeWithKey:key adcode:tip.adcode];
        
            weakSelf.searchBar.placeholder = tip.name;
    };
    
    vc.go = ^(AMapTip *tip){
        weakSelf.selectName = tip.name;
        NSString *key = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
        [weakSelf clearAndSearchGeocodeWithKey:key adcode:tip.adcode];
        
        weakSelf.searchBar.placeholder = tip.name;
        weakSelf.isReturn = YES;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    GeocodeAnnotation *anno = (GeocodeAnnotation *)view.annotation;

    if (![anno isKindOfClass:[GeocodeAnnotation class]]) {
        [self removeAnnotaionNoSelf];
    }
    [self setToolBarViewWithAnnotation:anno];
}

@end
