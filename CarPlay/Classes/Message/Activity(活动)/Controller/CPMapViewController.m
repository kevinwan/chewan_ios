//
//  CPMapViewController.m
//  CarPlay
//
//  Created by chewan on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMapViewController.h"
#import <MapKit/MapKit.h>
#import "CPAnnotation.h"
#import "CPAnotationView.h"

@interface CPMapViewController ()<MKMapViewDelegate, UISearchBarDelegate>
/**
 *  地图
 */
@property (weak, nonatomic) MKMapView *customMapView;
@property (nonatomic, strong) CLLocationManager *mgr;
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation CPMapViewController

- (NSMutableArray *)annotations
{
    if (_annotations == nil) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MKMapView *customMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:customMapView];
    self.customMapView = customMapView;
    // 1.设置地图显示的类型
    
    // 注意:在iOS8中, 如果想要追踪用户的位置, 必须自己主动请求隐私权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
    }
    
    // 设置不允许地图旋转
    self.customMapView.rotateEnabled = NO;
    
    // 成为mapVIew的代理
    self.customMapView.delegate = self;
    
    // 如果想利用MapKit获取用户的位置, 可以追踪
    self.customMapView.userTrackingMode =  MKUserTrackingModeFollow;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetZero;
    searchBar.placeholder = @"输入您的目的地";
    searchBar.scopeBarBackgroundImage = nil;
    searchBar.frame = CGRectMake(10, 74, kScreenWidth - 20, 44);
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;  
        }  
    }
    
//    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
//    [customMapView addGestureRecognizer:mTap];
//    [self geocodeBtnClick];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.customMapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.customMapView convertPoint:touchPoint toCoordinateFromView:self.customMapView];//这里touchMapCoordinate就是该点的经纬度了
    // 利用反地理编码获取位置之后设置标题
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        
    }];
    
}
- (void)add
{

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(30, 30);
    [self.customMapView setCenterCoordinate:coord animated:YES];
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
    //    userLocation.title = @"黑马";
    //    userLocation.subtitle = @"牛逼";
    
    // 利用反地理编码获取位置之后设置标题
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    
    
    
    // 移动地图到当前用户所在位置
    // 获取用户当前所在位置的经纬度, 并且设置为地图的中心点
    [self.customMapView setCenterCoordinate:userLocation.location.coordinate animated:NO];
    
    // 设置地图显示的区域
    // 获取用户的位置
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 指定经纬度的跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置显示区域
    [self.customMapView setRegion:region animated:NO];
}

/**
 *  地图的区域即将改变时调用
 
 - (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
 {
 NSLog(@"地图的区域即将改变时调用");
 }
 */
/**
 *  地图的区域改变完成时调用
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图的区域改变完成时调用");
    
    // 0.119170 0.100000
    // 0.238531 0.200156
    // 0.009310 0.007812
    NSLog(@"%f %f", self.customMapView.region.span.latitudeDelta, self.customMapView.region.span.longitudeDelta);
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)geocodeBtnClick
{
    // 0.获取用户输入的位置
    NSString *addressStr = @"你好";
    if (addressStr == nil || addressStr.length == 0) {
        NSLog(@"请输入地址");
        return;
    }
    
    
    // 1.创建地理编码对象
    
    // 2.利用地理编码对象编码
    // 根据传入的地址获取该地址对应的经纬度信息
    [self.geocoder geocodeAddressString:addressStr completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        // placemarks地标数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等...
        // 获取数组中的第一个地标
        CLPlacemark *placemark = [placemarks firstObject];
        //        for (CLPlacemark  *placemark in placemarks) {
        //            NSLog(@"%@ %@ %f %f", placemark.name, placemark.addressDictionary, placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
//        self.latitudeLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
//        self.longitudeLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
        NSArray *address = placemark.addressDictionary[@"FormattedAddressLines"];
        NSMutableString *strM = [NSMutableString string];
        for (NSString *str in address) {
            [strM appendString:str];
        }
        DLog(@"是打发的撒旦法师%@",strM);
        
        //        }
        
        
        
    }];
}

#pragma  mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text == nil) {
        
        return;
    }
    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        
        for (CLPlacemark *placeMark in placemarks) {
            CPAnnotation *annotation = [[CPAnnotation alloc] init];
            annotation.icon = @"费用";
            annotation.coordinate = placeMark.location.coordinate;
            NSArray *address = placeMark.addressDictionary[@"FormattedAddressLines"];
            NSMutableString *strM = [NSMutableString string];
            for (NSString *str in address) {
                [strM appendString:str];
            }
            annotation.title = placeMark.name;
            annotation.subtitle = strM;
            [self.customMapView addAnnotation:annotation];
//            [self.customMapView insert];
        }
        
        // placemarks地标数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等...
        // 获取数组中的第一个地标
        CLPlacemark *placemark = [placemarks firstObject];
        //        for (CLPlacemark  *placemark in placemarks) {
        //            NSLog(@"%@ %@ %f %f", placemark.name, placemark.addressDictionary, placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        //        self.latitudeLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
        //        self.longitudeLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
        NSArray *address = placemark.addressDictionary[@"FormattedAddressLines"];
        NSMutableString *strM = [NSMutableString string];
        for (NSString *str in address) {
            [strM appendString:str];
        }
        DLog(@"是打发的撒旦法师%@",strM);
        
        //        }
        
        
        
    }];

}

#pragma mark - 显示大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CPAnnotation class]] == NO) {
        return nil;
    }
    NSLog(@"%@",annotation);
    MKAnnotationView *view = [CPAnotationView annotationViewWithMapView:mapView];
    view.annotation = annotation;
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

@end
