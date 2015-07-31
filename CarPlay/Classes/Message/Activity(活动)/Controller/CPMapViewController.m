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
#import "CPAnnotation.h"
#import "CPAnotationView.h"
#import "ZYSearchBar.h"
#import "CPLocationModel.h"
#import <MapKit/MKAnnotation.h>
@interface CPMapViewController ()<MKMapViewDelegate, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,AMapSearchDelegate>
/**
 *  地图
 */
@property (weak, nonatomic) MKMapView *customMapView;
@property (nonatomic, strong) CLLocationManager *mgr;
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;

@property (nonatomic, weak) ZYSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *annotations;
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

- (NSMutableArray *)annotations
{
    if (_annotations == nil) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择活动地点";
    
    MKMapView *customMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:customMapView];
    self.customMapView = customMapView;
    // 1.设置地图显示的类型
    
    // 注意:在iOS8中, 如果想要追踪用户的位置, 必须自己主动请求隐私权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
        [self.mgr requestWhenInUseAuthorization];
        self.mgr.delegate = self;
    }
    
    // 设置不允许地图旋转
    self.customMapView.rotateEnabled = NO;
    
    // 成为mapVIew的代理
    self.customMapView.delegate = self;
    
    // 如果想利用MapKit获取用户的位置, 可以追踪
    self.customMapView.userTrackingMode =  MKUserTrackingModeFollow;
    ZYSearchBar *searchBar = [[ZYSearchBar alloc] init];
    
    searchBar.placeholder = @"输入您的目的地";
    searchBar.frame = CGRectMake(10, 74, kScreenWidth - 80, 40);
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
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
    [customMapView addGestureRecognizer:mTap];
    
    // 如果有值意味着修改位置 需要显示上一次的位置
    if (self.forValue) {
        CPLocationModel *model = (CPLocationModel *)self.forValue;
        CPAnnotation *annotation = [[CPAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
        annotation.title = model.location;
        annotation.icon = @"定位";
        self.searchBar.placeholder = model.location;
        CLLocationCoordinate2D center = annotation.coordinate;
        // 指定经纬度的跨度
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
        // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        // 设置显示区域
        [self.customMapView addAnnotation:annotation];
        [self.customMapView setRegion:region animated:NO];
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
    
    if (gestureRecognizer.view == self.customMapView) {
        self.resultTableView.hidden = YES;
        self.descLocationView.hidden = YES;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.customMapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.customMapView convertPoint:touchPoint toCoordinateFromView:self.customMapView];//这里touchMapCoordinate就是该点的经纬度了
    // 利用反地理编码获取位置之后设置标题
    [SVProgressHUD showWithStatus:@"加载中"];
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    regeo.requireExtension = YES;
    [self.searchApi AMapReGoecodeSearch:regeo];
}

- (void)removeAnnotaionNoSelf
{
    for (CPAnnotation *anno in self.customMapView.annotations){
        if ([anno isKindOfClass:[CPAnnotation class]]) {
            [self.customMapView removeAnnotation:anno];
        }
    }
}

#pragma MKMapViewDelegate

/**
 *  每次更新到用户的位置就会调用(调用不频繁, 只有位置改变才会调用)
 *
 *  @param mapView      促发事件的控件
 *  @param userLocation 大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
     地图上蓝色的点就称之为大头针
     大头针可以拥有标题/子标题/位置信息
     大头针上显示什么内容由大头针模型确定(MKUserLocation)
     */
    // 设置大头针显示的内容
    
    // 利用反地理编码获取位置之后设置标题
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (self.forValue){ //
            return;
        }else{
            
            CLPlacemark *placemark = [placemarks firstObject];
            NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
            userLocation.title = placemark.name;
            userLocation.subtitle = placemark.locality;
            
            self.userLocation =[self locationModelWithPlaceMark:placemark];
            
            // 如果没有定位成功过
            if (!self.orientationSuccess) {
                CLLocationCoordinate2D center = userLocation.location.coordinate;
                // 指定经纬度的跨度
                MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
                // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
                MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
                
                // 设置显示区域
                [self.customMapView setRegion:region animated:NO];
                self.orientationSuccess = YES;
            }
        }
    }];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (self.descLocationView.hidden == NO) {
        self.descLocationView.hidden = YES;
    }
    if (textField.text.length) {
        if (self.resultTableView.hidden == YES) {
            self.resultTableView.hidden = NO;
        }
        [self searchTipsWithKey:textField.text];
    }else{
        self.resultTableView.hidden = YES;
    }
    return YES;
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
            
            CPAnnotation *annotation = [[CPAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
            annotation.title = obj.formattedAddress;
            annotation.icon = @"定位";
            [annotations addObject:annotation];
        }];
        
        CPAnnotation *first = [annotations firstObject];
        
        CLLocationCoordinate2D center = first.coordinate;
        // 指定经纬度的跨度
        MKCoordinateSpan span = MKCoordinateSpanMake(0.005,0.005);
        // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        // 设置显示区域
        [self.customMapView setRegion:region animated:YES];
        
        [self.customMapView addAnnotations:annotations];
    }
    
}

/**
 *  逆地理编码回调
 *
 *  @param request  request description
 *  @param response response description
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        [self setDescViewWithModel:response.regeocode];
    }
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

/**
 *  根据placeMark生成locationModel
 *
 *  @param placeMark placeMark
 *
 *  @return
 */
- (CPLocationModel *)locationModelWithPlaceMark:(CLPlacemark *)placeMark
{
    CPLocationModel *model = [[CPLocationModel alloc] init];
    if (placeMark.locality == nil){
        model.city = placeMark.administrativeArea;
    }else{
        model.city = placeMark.locality;
    }
    NSLog(@"=====%f====%f",placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
    NSArray *address = placeMark.addressDictionary[@"FormattedAddressLines"];
    NSLog(@"%@,,,,,%@",address,placeMark.name);
    if (placeMark.name == nil){
        model.location = [address firstObject];
    }else{
        model.location = placeMark.name;
    }
    model.latitude = @(placeMark.location.coordinate.latitude);
    model.longitude = @(placeMark.location.coordinate.longitude);
    if (placeMark.subLocality) {
        model.district = placeMark.subLocality;
    }
    return model;
}

#pragma mark - 显示大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CPAnnotation class]] == NO) {
        return nil;
    }
    MKAnnotationView *view = [CPAnotationView annotationViewWithMapView:mapView];
    view.annotation = annotation;
    return view;
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

- (void)setDescViewWithModel:(AMapReGeocode *)reGeocode
{
    NSLog(@"%@lll",reGeocode.formattedAddress);
    self.descLocationView.hidden = NO;
    
    CPLocationModel *model = [[CPLocationModel alloc] init];
    
    
    AMapPOI *poi = [reGeocode.pois firstObject];
    
    model.location = poi.name;
    model.latitude = @(poi.location.latitude);
    model.longitude = @(poi.location.longitude);
    model.city = reGeocode.addressComponent.city;
    if (model.city.length == 0) {
        model.city = reGeocode.addressComponent.province;
    }
    model.district = reGeocode.addressComponent.district;
    model.province = reGeocode.addressComponent.province;
    model.address = reGeocode.formattedAddress;
    self.selectLocation = model;
    
    [self removeAnnotaionNoSelf];
    CPAnnotation *annotation = [[CPAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    annotation.title = poi.name;
    annotation.icon = @"定位";
    [self.customMapView addAnnotation:annotation];
    [self.customMapView setCenterCoordinate:annotation.coordinate animated:YES];
    
    UILabel *nameLabel = (UILabel *)[self.descLocationView viewWithTag:3];
    
    nameLabel.text = poi.name;
    self.searchBar.text = poi.name;
    self.searchBar.placeholder = poi.name;
    
    UILabel *addressLabel = (UILabel *)[self.descLocationView viewWithTag:4];
    addressLabel.text = reGeocode.formattedAddress;
    if (addressLabel.text.length == 0) {
        addressLabel.text = poi.address;
    }
    
    [SVProgressHUD dismiss];
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

@end
