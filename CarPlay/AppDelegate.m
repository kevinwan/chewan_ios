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
#import "ChatListViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "SDImageCache.h"
#import "CPNewfeatureViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#define kCheWanAppID @"55a34ed367e58e6efc00285d"
#define kWeiXinAppID @"wx4c127cf07bd7d80b"
#define kWeiXinAppSecret @"315ce754c5a1096c5188b4b69a7b9f04"

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
    [ZYNotificationCenter addObserver:self selector:@selector(loginOut) name:NOTIFICATION_LOGINOUT object:nil];
    [ZYNotificationCenter addObserver:self selector:@selector(clearSDWebImageCache) name:NOTIFICATION_CLEANSDCACSHEIMAGE object:nil];
    [SVProgressHUD setBackgroundColor:ZYColor(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    // 设置点击空白区域退出键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
//    友盟第三方登录
    [UMSocialData setAppKey:@"55a34ed367e58e6efc00285d"];
    
    [UMSocialWechatHandler setWXAppId:@"wx4c127cf07bd7d80b" appSecret:@"315ce754c5a1096c5188b4b69a7b9f04" url:@"http://www.umeng.com/social"];
    //QQ登录
    [UMSocialQQHandler setQQWithAppId:@"1104728007" appKey:@"61BpHk8GQwH6FuCs" url:@"http://www.umeng.com/social"];
    [UMSocialData openLog:NO];
    [self getLocation];
    //环信
    
    //环信注册推送
    [self registerRemoteNotification];
    //gongpingjia#carplayapp
    //"easemob-demo#chatdemoui
    //
        [[EaseMob sharedInstance] registerSDKWithAppKey:Easy_Mob_Key apnsCertName:APNS_CER];

//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"gongpingjia#carplayapp" apnsCertName:@"chewanvpntest"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
   
    
    
    if (CPIsLogin) {
        [self upDateUserInfo];
    }
    // 如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        // 当前版本号 == 上次使用的版本：显示HMTabBarViewController
        self.window.rootViewController = _tabVc;
        [self.window makeKeyAndVisible];
    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
        self.window.rootViewController = [[CPNewfeatureViewController alloc] init];
        // 存储这次使用的软件版本
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //友盟
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2389475444" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.childViewControllers.firstObject isKindOfClass:[CPMyViewController class]]) {
        if (CPIsLogin) {
            return YES;
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录是否登录？" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去登录", nil] show];
            return NO;
        }
    }else if ([nav.childViewControllers.firstObject isKindOfClass:[ChatListViewController class]])
    {
        if (CPIsLogin) {
            return YES;
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录是否登录？" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去登录", nil] show];
            return NO;
        }
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex !=4) {
        [ZYUserDefaults setInteger:tabBarController.selectedIndex forKey:TabLastSelectIndex];
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self goLogin];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
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

- (void)clearSDWebImageCache
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
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
        [UMSocialSnsService  applicationDidBecomeActive];
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
-(void)loginOut{
    self.window.rootViewController = _tabVc;
    [_tabVc setSelectedIndex:0];
    [self.window makeKeyAndVisible];
}

-(void)getLocation{
//    [self setViewCycleAop];
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
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录是否登录？" delegate:self cancelButtonTitle:@"在想想" otherButtonTitles:@"去登录", nil] show];
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
            [ZYUserDefaults setObject:placemark.addressDictionary[@"Street"] forKey:Street];
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

-(void)upDateUserInfo{
     NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:@"phone"],@"phone",[ZYUserDefaults stringForKey:@"password"],@"password",nil];
    [ZYNetWorkTool postJsonWithUrl:@"user/login" params:paras success:^(id responseObject) {
        if (CPSuccess) {
            CPUser *user = [CPUser objectWithKeyValues:responseObject[@"data"]];
            if (user.album.count > 0) {
                
                [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                
            }else{
                
                [ZYUserDefaults setBool:NO forKey:CPHasAlbum];
            }
            NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
            [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
            if (responseObject[@"data"][@"userId"]) {
                [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
            }
            if (responseObject[@"data"][@"token"]) {
                [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
            }
            [ZYUserDefaults setObject:responseObject[@"data"][@"nickname"] forKey:kUserNickName];
            [ZYUserDefaults setObject:responseObject[@"data"][@"avatar"] forKey:kUserHeadUrl];
            [ZYUserDefaults setObject:responseObject[@"data"][@"age"] forKey:kUserAge];
            [ZYUserDefaults setObject:responseObject[@"data"][@"gender"] forKey:KUserSex];
            [ZYUserDefaults setBool:user.idle forKey:FreeTimeKey];
            [ZYNotificationCenter postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil userInfo:@{NOTIFICATION_LOGINSUCCESS:@(YES)}];
        }else{
            [ZYNotificationCenter postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil userInfo:@{NOTIFICATION_LOGINSUCCESS:@(NO)}];
        }
    } failed:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
         [ZYNotificationCenter postNotificationName:NOTIFICATION_LOGINSUCCESS object:nil userInfo:@{NOTIFICATION_LOGINSUCCESS:@(NO)}];
    }];
    
}

- (void)dealloc
{
    [ZYNotificationCenter removeObserver:self];
}
#pragma mark huanxin
// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSLog(@"deviceToken是%@",deviceToken);
}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}
@end
