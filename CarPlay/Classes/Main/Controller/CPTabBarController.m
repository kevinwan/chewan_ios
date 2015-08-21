//
//  CPTabBarController.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPCityController.h"
#import "CPMessageController.h"
#import "CPMyController.h"
#import "EMCDDeviceManager.h"
#import "LoginViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface CPTabBarController ()<IChatManagerDelegate>
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation CPTabBarController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *v = [[UIView alloc] initWithFrame:self.tabBar.bounds];  
//    v.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bt_bg"]];
//    [self.tabBar insertSubview:v atIndex:0];
    
    // 同城
    [self addChildVCWithSBName:@"CPCityController" title:@"同城" norImageName:@"同城" selectedImageName:@"同城选中"];
    // 消息
    [self addChildVCWithSBName:@"CPMessageController" title:@"消息" norImageName:@"消息" selectedImageName:@"消息选中"];
    
    // 我的
    [self addChildVCWithSBName:@"CPMyController" title:@"我的" norImageName:@"我的" selectedImageName:@"我的选中"];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self setupUnreadMessageCount];
 
}

- (void)addChildVCWithClass:(Class)class title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{
    UIViewController *vc4 = [[class alloc] init];
    [self addChildVCWithController:vc4 title:title norImageName:norImageName selectedImageName:selectedImageName];
}

- (void)addChildVCWithSBName:(NSString *)sbName  title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{
    // 1.加载Storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    // 2.创建Storyboard中的初始控制器
    UINavigationController *nav = sb.instantiateInitialViewController;
    // 3.调用addChildVCWithController
    [self addChildVCWithController:nav.topViewController title:title norImageName:norImageName selectedImageName:selectedImageName];
}

- (void)addChildVCWithController:(UIViewController *)vc  title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{
    
    // 设置标题
    vc.tabBarItem.title = title;
    vc.navigationItem.title = title;
    // 设置默认图片
    vc.tabBarItem.image = [UIImage imageNamed:norImageName];
    // 设置选中图片
    UIImage *selectedImage =  [UIImage imageNamed:selectedImageName];
    // 不渲染图片
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = selectedImage;
    //设置tabBar标题颜色 也可在storyboard中设置
    self.tabBar.tintColor = [Tools getColor:@"48d1d5"];
    
    
    // 设置随机色
//    vc.view.backgroundColor = CPRandomColor;
    // 添加到父控件
    [self addChildViewController:vc.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    CPMessageController *CPMessageVc = (CPMessageController *)[self.childViewControllers[1] topViewController];
    [CPMessageVc  refreshDataSource];
}

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账号从其他设备上登录，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        
        EMError *error1 = nil;
        NSDictionary *info1 = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];
        if (!error1 && info1) {
            [Tools setValueForKey:@(NO) key:NOTIFICATION_HASLOGIN];
            [Tools setValueForKey:nil key:@"userId"];
            LoginViewController *loginVC=[[LoginViewController alloc]init];
            UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:loginVC];
            self.view.window.rootViewController=nav1;
            [self.view.window makeKeyAndVisible];
        }else{
            [self showError:error1.description];
        }
    } onQueue:nil];
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

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
//    UIViewController *vc = self.childViewControllers[1];
//    NSInteger badgeValue = [vc.tabBarItem.badgeValue integerValue] + unreadCount;
    
    if (unreadCount > 0) {
        [self.tabBar showBadgeOnItemIndex:1];
    }else{
        [self.tabBar hideBadgeOnItemIndex:1];
    }
    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
}
- (void)didReceiveMessage:(EMMessage *)message{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"图片";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"位置";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"语音";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"视频";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您收到一条消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
//        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
//                                                            message:hintText
//                                                           delegate:self
//                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
//                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
//                                  nil];
//        alertView.tag = 99;
//        [alertView show];
          CPMessageController *CPMessageVc = (CPMessageController *)[self.childViewControllers[1] topViewController];
        [CPMessageVc isConnect:NO];
         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
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
