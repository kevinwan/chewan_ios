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
#import "UMSocialQQHandler.h"
#import "CPNewfeatureViewController.h"
#import <MobClick.h>
#define kCheWanAppID @"55a34ed367e58e6efc00285d"
#define kWeiXinAppID @"wx4c127cf07bd7d80b"
#define kWeiXinAppSecret @"315ce754c5a1096c5188b4b69a7b9f04"
@interface AppDelegate ()<UIAlertViewDelegate>

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
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    // 开始监控网络状态
    [self startMonitoringNetWork];
    _tabVc = [[CPTabBarController alloc] init];
    
    UIView *bgView = [[UIView alloc] initWithFrame:_tabVc.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [_tabVc.tabBar insertSubview:bgView atIndex:0];
    _tabVc.tabBar.opaque = YES;
    
    [UMSocialData setAppKey:kCheWanAppID];
    // 微信分享
    [UMSocialWechatHandler setWXAppId:kWeiXinAppID appSecret:kWeiXinAppSecret url:nil];
    //QQ登录
    [UMSocialQQHandler setQQWithAppId:@"1104728007" appKey:@"61BpHk8GQwH6FuCs" url:@"http://www.umeng.com/social"];
//    统计分析  nil默认渠道为appStore
    [MobClick startWithAppkey:kCheWanAppID reportPolicy:BATCH   channelId:nil];
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"gongpingjia#chewantest" apnsCertName:@"carPlayApns"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
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
    [self loadUnReadData];
    return YES;
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

#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
 
    if ([Tools getValueFromKey:@"userId"]) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        self.window.rootViewController = _tabVc;
        [self.window makeKeyAndVisible];
    }else{//登陆失败加载登陆页面控制器
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登陆是否登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登陆", nil] show];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清空图片缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDisk];
}

- (void)startMonitoringNetWork
{
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable){
            [CPUserDefaults setBool:YES forKey:CPNetWorkStatus];
            [CPUserDefaults synchronize];
        }else{
            [CPUserDefaults setBool:NO forKey:CPNetWorkStatus];
            [CPUserDefaults synchronize];
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        LoginViewController *loginVC=[[LoginViewController alloc]init];
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController=nav1;
        [self.window makeKeyAndVisible];
    }
}

- (void)loadUnReadData
{
    if (CPUnLogin) {
        return;
    }
    NSString *userid = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/message/count?token=%@", userid, token];
    [ZYNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        if (CPSuccess) {
            
            NSDictionary *comment = responseObject[@"data"][@"comment"];
            
            NSDictionary *application = responseObject[@"data"][@"application"];
            
            NSUInteger newMsgCount = [comment[@"count"] intValue];
            NSUInteger activityApplyCount = [application[@"count"] intValue];
            
            UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UIViewController *vc = tabVc.childViewControllers[1];
            if (newMsgCount + activityApplyCount > 0) {
            vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",newMsgCount+ activityApplyCount];
            }else{
                vc.tabBarItem.badgeValue = nil;
            }
        
        }
    } failure:^(NSError *error) {
        
    }];
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

- (void)didReceiveMessage:(EMMessage *)message{
    NSLog(@"%@",message);
}

/*!
 @method
 @brief 接受群组邀请并加入群组后的回调
 @param group 所接受的群组
 @param error 错误信息
 */
- (void)didAcceptInvitationFromGroup:(EMGroup *)group error:(EMError *)error{
    
}

/*!
 @method
 @brief 群组信息更新后的回调
 @param group 发生更新的群组
 @param error 错误信息
 @discussion
 当添加/移除/更改角色/更改主题/更改群组信息之后,都会触发此回调
 */
- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error{
    
}

/*!
 @method
 @brief 申请加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didApplyJoinPublicGroup:(EMGroup *)group
                          error:(EMError *)error{
    
}

/*!
 @method
 @brief 收到加入群组的申请
 @param groupId         要加入的群组ID
 @param groupname       申请人的用户名
 @param username        申请人的昵称
 @param reason          申请理由
 @discussion
 */
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error{
    
}

/*!
 @method
 @brief 加入公开群组后的回调
 @param group 群组对象
 @param error 错误信息
 */
- (void)didJoinPublicGroup:(EMGroup *)group
                     error:(EMError *)error{
    
}

/*!
 @method
 @brief 离开一个群组后的回调
 @param group  所要离开的群组对象
 @param reason 离开的原因
 @param error  错误信息
 @discussion
 离开的原因包含主动退出, 被别人请出, 和销毁群组三种情况
 */
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error{
    
}

/*!
 @method
 @brief 离开一个群组后的回调
 @param group  所要离开的群组对象
 @param reason 离开的原因
 @param error  错误信息
 @discussion
 离开的原因包含主动退出, 被别人请出, 和销毁群组三种情况
 */
//- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error{
//    
//}
@end
