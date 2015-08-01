//
//  CPMapViewController.m
//  CarPlay
//
//  Created by chewan on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMapViewController.h"
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import <AMapSearchKit/AMapSearchObj.h>
//#import "CPAnnotation.h"
//#import "CPAnotationView.h"
#import "ZYSearchBar.h"
#import "CPLocationModel.h"
#import <MapKit/MKAnnotation.h>
#import <AMap2DMap/MAMapKit.h>
#import "GeocodeAnnotation.h"
#import "CommonUtility.h"

@interface CPMapViewController ()<MKMapViewDelegate, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,AMapSearchDelegate,MAMapViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CLLocationManager *mgr;
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;

@property (nonatomic, weak) ZYSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, assign) BOOL orientationSuccess;
@property (nonatomic, strong) CPLocationModel *userLocation;
@property (nonatomic, strong) CPLocationModel *selectLocation;
@property (nonatomic, strong) UIView *descLocationView;
@property (nonatomic, strong) AMapSearchAPI *searchApi;
@property (nonatomic, strong) AMapTip *selectTip;
@property (nonatomic, assign) BOOL isReturn;
@property (nonatomic, copy) NSString *selectName;
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation CPMapViewController

- (NSMutableArray *)tips
{
    if (_tips == nil) {
        _tips = [NSMutableArray array];
    }
    return _tips;
}

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
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:@"选择>" forState:UIControlStateNormal];
        [button setTitleColor:[Tools getColor:@"48d1d5"] forState:UIControlStateNormal];
        button.width = 50;
        button.height = 30;
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
    _mapView.delegate = self;
    _mapView.zoomLevel = 5;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    [self.view addSubview:_mapView];

    ZYSearchBar *searchBar = [[ZYSearchBar alloc] init];
    
    searchBar.placeholder = @"输入您的目的地";
    searchBar.frame = CGRectMake(10, 74, kScreenWidth - 80, 40);
    [self.view addSubview:searchBar];
    [searchBar addTarget:self action:@selector(inputTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchBar = searchBar;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[Tools getColor:@"fd6d53"]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(searchBar.right + 5, 76, 55, searchBar.height- 5);
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = 50;
    tableView.hidden = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.frame = CGRectMake(searchBar.x, searchBar.bottom,kScreenWidth - 2 * searchBar.x , kScreenHeight - searchBar.bottom - 44);
    tableView.tableFooterView = [[UIView alloc] init];
    self.resultTableView = tableView;

    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    mTap.delegate = self;
    [self.mapView addGestureRecognizer:mTap];
    
    // 如果有值意味着修改位置 需要显示上一次的位置
    if (self.forValue) {
        CPLocationModel *model = (CPLocationModel *)self.forValue;
        GeocodeAnnotation *annotation = [[GeocodeAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
        annotation.title = model.location;
        self.searchBar.placeholder = model.location;
        CLLocationCoordinate2D center = annotation.coordinate;
        
        // 指定经纬度的跨度
        MACoordinateSpan span = MACoordinateSpanMake(0.005,0.005);
        MACoordinateRegion region = MACoordinateRegionMake(center, span);
        
        // 设置显示区域
        [self.mapView setRegion:region animated:YES];
        [self.mapView addAnnotation:annotation];
    }
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
        if (self.orientationSuccess == NO && self.forValue== nil) {
            // 指定经纬度的跨度
            MACoordinateSpan span = MACoordinateSpanMake(0.005,0.005);
            MACoordinateRegion region = MACoordinateRegionMake(userLocation.coordinate, span);
            [self.mapView setRegion:region animated:YES];
            self.orientationSuccess = YES;
        }
    }
}
#pragma mark - 处理按钮点击

- (void)searchBtnClick
{
    [self.searchBar resignFirstResponder];
    self.resultTableView.hidden = YES;
    if (self.searchBar.text.length) {
        [self clearAndSearchGeocodeWithKey:self.searchBar.text adcode:nil];
    }else{
        [SVProgressHUD showInfoWithStatus:@"输入不能为空"];
    }
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    [self.searchBar resignFirstResponder];
    
    if (gestureRecognizer.view == self.mapView) {
        self.resultTableView.hidden = YES;
        self.descLocationView.hidden = YES;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    // 利用反地理编码获取位置之后设置标题
    [SVProgressHUD showWithStatus:@"加载中"];
    
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
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



//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    regeo.requireExtension = YES;
//    [self.searchApi AMapReGoecodeSearch:regeo];
}

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [SVProgressHUD dismiss];
    if(response.pois.count == 0)
    {
        return;
    }
    
    [self setDescViewWithModel:response];
    //通过AMapPlaceSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %zd",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

- (void)removeAnnotaionNoSelf
{
    for (GeocodeAnnotation *anno in self.mapView.annotations){
        if ([anno isKindOfClass:[GeocodeAnnotation class]]) {
            [self.mapView removeAnnotation:anno];
        }
    }
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
        NSMutableArray *annotations = [NSMutableArray array];
        
        [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
            
            GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
            [annotations addObject:geocodeAnnotation];
        }];
        
        if (annotations.count == 1)
        {
            // 指定经纬度的跨度
            MACoordinateSpan span = MACoordinateSpanMake(0.005,0.005);
            MACoordinateRegion region = MACoordinateRegionMake([annotations[0] coordinate], span);
            [self.mapView setRegion:region animated:YES];
        }
        else
        {
            [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
                                   animated:YES];
        }
        
        [self.mapView addAnnotations:annotations];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"定位"];
        
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showInfoWithStatus:@"未知错误"];
}

/**
 *  显示模糊搜索的数据
 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips removeAllObjects];
    if (response.tips.count) {
        [self.tips addObjectsFromArray:response.tips];
    }
    [self.resultTableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.imageView.image = [UIImage imageNamed:@"定位icon"];
        cell.detailTextLabel.textColor = [Tools getColor:@"aab2bd"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [Tools getColor:@"434a54"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"去这里" forState:UIControlStateNormal];
        [button sizeToFit];
        cell.accessoryView = button;
    }
    AMapTip *tip = self.tips[indexPath.row];
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.district;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    self.resultTableView.hidden = YES;
    AMapTip *tip = self.tips[indexPath.row];
    self.selectTip = tip;
    NSString *key = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
    [self clearAndSearchGeocodeWithKey:key adcode:tip.adcode];
    
    self.searchBar.placeholder = tip.name;
}

- (void)setDescViewWithModel:(AMapPlaceSearchResponse *)reGeocode
{
    self.descLocationView.hidden = NO;
    
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
    self.selectLocation = model;
    
    [self removeAnnotaionNoSelf];
    
    GeocodeAnnotation *annotation = [[GeocodeAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    annotation.title = poi.name;
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    
    UILabel *nameLabel = (UILabel *)[self.descLocationView viewWithTag:3];
    
    nameLabel.text = poi.name;
    self.searchBar.text = poi.name;
    self.searchBar.placeholder = poi.name;
    
    UILabel *addressLabel = (UILabel *)[self.descLocationView viewWithTag:4];
    addressLabel.text = poi.address;
    if (addressLabel.text.length == 0) {
        addressLabel.text = model.address;
    }
}

/**
 *  选中地址
 */
- (void)go:(UIButton *)button
{
    
    AMapTip *tip = [self.tips objectAtIndex:button.tag];
    
    self.selectName = tip.name;
    
    NSString *key = [NSString stringWithFormat:@"%@%@", tip.district, tip.name];
    self.isReturn = YES;
    [SVProgressHUD showWithStatus:@"加载中"];
    [self searchGeocodeWithKey:key adcode:tip.adcode];
}

- (void)goThere
{
    if (self.completion) {
        self.completion(self.selectLocation);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
*  下面的方法用来设置tableView全屏的分割线
*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.resultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.resultTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.resultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.resultTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    if (mapView.zoomLevel > 18.5) {
        [mapView setZoomLevel:18.5 animated:YES];
    }
}

@end
