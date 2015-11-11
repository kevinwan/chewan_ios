//
//  CPTabBarController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPTabBar.h"
#import "CPNavigationController.h"
#import "CPNearViewController.h"
#import "CPMyViewController.h"
#import "CPMyCareController.h"
#import "CPTestPhotoViewController.h"
#import "CPMatchingViewController.h"
#import "ChatListViewController.h"
#import "CPRecommendController.h"
#import "CallViewController.h"
#import "ChatViewController.h"
#import "CPMatchingResultController.h"
@interface CPTabBarController () <CPTabBarDelegate>

@end

@implementation CPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.初始化子控制器
    
    CPNearViewController *nearVc1 = [[CPNearViewController alloc] init];
    [self addChildVc:nearVc1 title:@"附近" image:@"NearUnSelect" selectedImage:@"NearSelect"];
    
    CPRecommendController *nearVc2 = [[CPRecommendController alloc] init];
    [self addChildVc:nearVc2 title:@"推荐" image:@"RecommendUnSelect" selectedImage:@"RecommendSelect"];
    
    ChatListViewController *vc3 = [[ChatListViewController alloc]init];
    [self addChildVc:vc3 title:@"动态" image:@"DynamicUnSelect" selectedImage:@"DynamicSelect"];
    
    CPMyViewController *nearVc4 = [UIStoryboard storyboardWithName:@"CPMyViewController" bundle:nil].instantiateInitialViewController;
    [self addChildVc:nearVc4 title:@"我的" image:@"MineUnSelect" selectedImage:@"MineSelect"];

    CPMatchingResultController *nearVc5 = [[CPMatchingResultController alloc] init];
    [self addChildVc:nearVc5 title:@"匹配结果" image:@"MineUnSelect" selectedImage:@"MineSelect"];
    // 2.更换系统自带的tabbar
    CPTabBar *tabBar = [[CPTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    [self.tabBar setTintColor:RedColor];
    
    UITabBarItem *itemApp = [UITabBarItem appearance];
    [itemApp setTitleTextAttributes:@{NSFontAttributeName : ZYFont12} forState:UIControlStateNormal];
    
    //设置未读消息数
    [self registerNotifications];
    [self setupUnreadMessageCount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClearUnreadMessageCount) name:@"DID_LOG_OUT_SUCCESS" object:nil];
}


/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    if (!childVc) {
        return;
    }
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    CPNavigationController *nav = [[CPNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //app第一次安装的时候，显示小红点
    BOOL firstInstall = [ZYUserDefaults boolForKey:First_install_app];
    if (!firstInstall) {
        [self.tabBar showBadgeOnItemIndex:3];
        if (CPIsLogin) {
            [ZYUserDefaults setBool:YES forKey:First_install_app];
        }
    }
}
#pragma mark - CPTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(CPTabBar *)tabBar
{
    

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":@"chewan123", @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
//    return;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":@"b17ea9f2e64fa8702a39f32cfe8715af", @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
//    return;
    //小牛的环信id：
//    b17ea9f2e64fa8702a39f32cfe8715af
    //test 测试语音聊天，暂时用下这个位置
    CPMatchingViewController *mathching=[UIStoryboard storyboardWithName:@"CPMatching" bundle:nil].instantiateInitialViewController;
     CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:mathching];
//    NSLog(@"%@",self.childViewControllers);
    [self setSelectedIndex:4];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark 动态未读消息提示
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];

    
            NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (unreadCount>0) {
        
        NSLog(@"=======有未读消息");
        [self.tabBar showBadgeOnItemIndex:3];
    }else{
        NSLog(@"=======未读消息清空了");
        [self.tabBar hideBadgeOnItemIndex:3];
    }
    
//    if (_chatListVC) {
//        if (unreadCount > 0) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
}
//当用户退出时，去掉动态的未读消息提示
- (void)ClearUnreadMessageCount
{
    [self.tabBar hideBadgeOnItemIndex:3];

}
#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];

}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}
-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}
#pragma mark - call

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alt show];
    }
    
    return bCanRecord;
}

- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (![self canRecord]) {
            return;
        }
        
        EMError *error = nil;
        NSString *chatter = [object objectForKey:@"chatter"];
        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
        EMCallSession *callSession = nil;
        if (type == eCallSessionTypeAudio) {
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
        }
        else if (type == eCallSessionTypeVideo){
            if (![CallViewController canVideo]) {
                return;
            }
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
        }
        
        if (callSession && !error) {
            
            [[EaseMob sharedInstance].callManager removeDelegate:self];
            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:callController animated:NO completion:nil];
            

            
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [audioSession setActive:YES error:nil];
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusConnected)
    {
        EMError *error = nil;
        do {
            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
            if (isShowPicker) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (![self canRecord]) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
#warning 在后台不能进行视频通话
            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive || ![CallViewController canVideo])){
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (!isShowPicker){
                
                //获取对方的头像和昵称
                [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/emchatInfo?userId=%@&token=%@&emchatName=%@",CPUserId,CPToken,callSession.sessionChatter] params:nil success:^(id responseObject) {
                    if (CPSuccess) {
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
                        [ZYUserDefaults setObject:[dic objectForKey:@"avatar"] forKey:kSendCallHeadURL];
                        [ZYUserDefaults setObject:[dic objectForKey:@"nickname"] forKey:kSendCallNickName];
                        
                        
                        
                        
                        [[EaseMob sharedInstance].callManager removeDelegate:self];
                        CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES];
                        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        [self presentViewController:callController animated:NO completion:nil];
                        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]])
                        {
                            ChatViewController *chatVc = (ChatViewController *)self.navigationController.topViewController;
                            chatVc.isInvisible = YES;
                        }

                        
                    }
                } failure:^(NSError *error) {
                    ;
                }];
                

            }
        } while (0);
        
        if (error) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReasonHangup];
            return;
        }
    }
}
#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.beginAutoLogin", @"Start automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        
        // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
        [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        //获取数据库中的数据
        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    }
    
    [alertView show];
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
        //获取群组列表
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
        
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.endAutoLogin", @"End automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    }
    
    [alertView show];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账号在其他设备登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
    } onQueue:nil];
}

- (void)dealloc
{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
