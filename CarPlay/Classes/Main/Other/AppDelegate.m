//
//  AppDelegate.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CPTabBarController.h"
#import <MAMapKit/MAMapKit.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import <MobClick.h>
#define kCheWanAppID @"55a34ed367e58e6efc00285d"
#define kWeiXinAppID @"wx4c127cf07bd7d80b"
#define kWeiXinAppSecret @"315ce754c5a1096c5188b4b69a7b9f04"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动时隐藏状态栏,设置白色的状态栏
    [application setStatusBarHidden:NO];
    application.statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:NOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [MAMapServices sharedServices].apiKey = GaoDeAppKey;
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    [UMSocialData setAppKey:kCheWanAppID];
    // 微信分享
    [UMSocialWechatHandler setWXAppId:kWeiXinAppID appSecret:kWeiXinAppSecret url:nil];
//    统计分析  nil默认渠道为appStore
    [MobClick startWithAppkey:kCheWanAppID reportPolicy:BATCH   channelId:nil];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
 
    if ([Tools getValueFromKey:@"userId"]) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        CPTabBarController *tabBarController=[[CPTabBarController alloc]init];
        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];
    }else{//登陆失败加载登陆页面控制器
        LoginViewController *loginVC=[[LoginViewController alloc]init];
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController=nav1;
        [self.window makeKeyAndVisible];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清空图片缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDisk];
}

@end
