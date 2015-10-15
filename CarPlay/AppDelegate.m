//
//  AppDelegate.m
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "AppDelegate.h"
#import "Aspects.h"
#import "CPMyViewController.h"
#import "IQKeyboardManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CPLoginViewController.h"
#import "CPNavigationController.h"

@interface AppDelegate ()<UITabBarControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

/**
 *  定位管理者
 */
@property (nonatomic ,strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _tabVc = [CPTabBarController new];
    _tabVc.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _tabVc;
    [self.window makeKeyAndVisible];
    [ZYNotificationCenter addObserver:self selector:@selector(loginStateChang) name:NOTIFICATION_HASLOGIN object:nil];
    [ZYNotificationCenter addObserver:self selector:@selector(goLogin) name:NOTIFICATION_GOLOGIN object:nil];
    
    [SVProgressHUD setBackgroundColor:ZYColor(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    // 设置点击空白区域退出键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [self setViewCycleAop];
    
    self.mgr.delegate = self;
    // 判断是否是iOS8
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        NSLog(@"是iOS8");
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
    }else
    {
        NSLog(@"是iOS7");
        // 3.开始监听(开始获取位置)
        [self.mgr startUpdatingLocation];
    }
    //环信
    //gongpingjia#carplayapp
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"easemob-demo#chatdemoui" apnsCertName:@"istore_dev"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"offen3" password:@"123" completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        }
    } onQueue:nil];
    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.childViewControllers.firstObject isKindOfClass:[CPMyViewController class]]) {
        if (CPIsLogin) {
            return YES;
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录是否登录？" delegate:self cancelButtonTitle:@"在想想" otherButtonTitles:@"去登录", nil] show];
            return NO;
        }
    }
    return YES;
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self goLogin];
    }
}

- (void)setViewCycleAop
{
    
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"viewDidLoad") withOptions:AspectPositionAfter usingBlock:^(id info){

        if (![[info instance] isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            
        }else if ([[info instance] isKindOfClass:[UITableViewController class]]){
         
        }
        
    }error:NULL];
    
    /**
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"viewWillDisappear:") withOptions:AspectPositionBefore usingBlock:^(id info){
        
        if (![[info instance] isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            
            NSLog(@"%@viewWillDisappear..",[[info instance] class]);
        }
    }error:NULL];
    
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id info){
        
        if (![[info instance] isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            NSLog(@"%@ dealloc..",[[info instance] class]);
        }
    }error:NULL];
     */
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
[[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
[[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

-(void)loginStateChang{
    self.window.rootViewController = _tabVc;
    [self.window makeKeyAndVisible];
}

-(void)goLogin{
    CPLoginViewController *login = [UIStoryboard storyboardWithName:@"CPLoginViewController" bundle:nil].instantiateInitialViewController;
    CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

/**
 *  授权状态发生改变时调用
 *
 *  @param manager 触发事件的对象
 *  @param status  当前授权的状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {
        NSLog(@"授权成功");
        // 开始定位
        [self.mgr startUpdatingLocation];
        
    }else
    {
        NSLog(@"授权失败");
    }
}

#pragma mark - CLLocationManagerDelegate
/**
 *  获取到位置信息之后就会调用(调用频率非常高)
 *
 *  @param manager   触发事件的对象
 *  @param locations 获取到的位置
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    // 如果只需要获取一次, 可以获取到位置之后就停止
    //    [self.mgr stopUpdatingLocation];
    
    // 1.获取最后一次的位置
    /*
     location.coordinate; 坐标, 包含经纬度
     location.altitude; 设备海拔高度 单位是米
     location.course; 设置前进方向 0表示北 90东 180南 270西
     location.horizontalAccuracy; 水平精准度
     location.verticalAccuracy; 垂直精准度
     location.timestamp; 定位信息返回的时间
     location.speed; 设备移动速度 单位是米/秒, 适用于行车速度而不太适用于不行
     */
    /*
     可以设置模拟器模拟速度
     bicycle ride 骑车移动
     run 跑动
     freeway drive 高速公路驾车
     */
    CLLocation *location = [locations lastObject];
    [ZYUserDefaults setDouble:location.coordinate.latitude forKey:Latitude];
    [ZYUserDefaults setDouble:location.coordinate.longitude forKey:Longitude];
    [self.mgr stopUpdatingLocation];
    
    if (!location) {
        return;
    }
    // 根据CLLocation对象获取对应的地标信息
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
    
            [ZYUserDefaults setObject:placemark.addressDictionary[@"State"] forKey:Province];
            [ZYUserDefaults setObject:placemark.addressDictionary[@"City"] forKey:City];
            [ZYUserDefaults setObject:placemark.addressDictionary[@"SubLocality"] forKey:District];
        }
    }];

    
}

#pragma mark - 懒加载
- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
