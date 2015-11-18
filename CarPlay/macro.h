//
//  malco.h
//  chewan
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#ifndef malco_h
#define malco_h

// 正式服务器接口地址
#define BASE_URL @"http://chewanapi.gongpingjia.com/v2/"
//环信的key和推送证书，同样是正式服务器中的
#define Easy_Mob_Key @"gongpingjia#chewanapi"
#define APNS_CER @"chewanvpnrelease"

// 测试服务器接口地址
//#define BASE_URL @"http://cwapi.gongpingjia.com:8080/v2/"
//#define Easy_Mob_Key @"gongpingjia#carplayapp"
//#define APNS_CER @"chewanvpntest"


//==============================DLog/NSLog=====================
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif

// 定义这个宏可以使用一些更简洁的方法,发现与ZYExtension冲突
//#define MAS_SHORTHAND

// 定义这个宏可以使用自动装箱功能
#define MAS_SHORTHAND_GLOBALS

#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480.0)
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667.0)
#define iPhone6P ([UIScreen mainScreen].bounds.size.height == 736.0)
#define BundleId  [NSBundle mainBundle].infoDictionary[ (__bridge NSString *)kCFBundleIdentifierKey]

#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])   //当前设备的系统版本
#define iOS7 (SystemVersion >= 7.0 && SystemVersion < 8.0)
#define iOS8 (SystemVersion >= 8.0 && SystemVersion < 9.0)
#define iOS9 (SystemVersion >= 9.0 && SystemVersion < 10.0)
#define CPPageNum       10

#define CPNoNetWork     ([Tools isNoNetWork])  // 判断网络状态
#define CPUserId        [Tools getUserId]    // 获取userId
#define CPToken         [Tools getToken]    // 获取token
#define CPLatitude      [Tools getLatitude] //获取经度
#define CPLongitude     [Tools getLongitude] //获取维度
#define ZYLoadingView   self

#define CPIsLogin       ([Tools isLogin])   // 是否登录成功
#define CPUnLogin       ([Tools isUnLogin]) // 是否登录成功
#define CPSuccess       ([responseObject[@"result"] intValue] == 0)
#define CPErrorMsg      responseObject[@"errmsg"]
#define CPFailure       ([responseObject[@"result"] intValue] == 1)
#define CPPlaceHolderImage [UIImage imageNamed:@"未认证-审核中"]
#define CPHasAlbum @"CPHasAlbum"

//登录状态改变
#define NOTIFICATION_LOGINCHANGE @"loginStatusChange"
#define NOTIFICATION_ROOTCONTROLLERCHANGETOTAB @"rootControllerChangeToTab"
#define NOTIFICATION_HASLOGIN @"hasLogin"
#define NOTIFICATION_LOGINOUT @"loginOut"
#define NOTIFICATION_GOLOGIN @"goLogin"
#define NOTIFICATION_LOGINSUCCESS @"loginSuccess"
#define THIRDPARTYLOGINACCOUNT @"3partyLoginAccount"
#define CPReRefreshNotification @"CPReRefreshNotification"
#define CPSelectModelFilePath @"selectModel.data".documentPath

//清理SD缓存图片
#define NOTIFICATION_CLEANSDCACSHEIMAGE @"cleanSDCacheImage"
//开始意向匹配
#define NOTIFICATION_STARTMATCHING @"startMatching"

// 快速校验是否登录,弹框,跳转登录页面
#define CPGoLogin(title) \
if (CPUnLogin) {\
NSString *message = [NSString stringWithFormat:@"你还未登录,登录后就可以%@",title];\
UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"再想想" otherButtonTitles:@"去登录", nil];\
[alertView.rac_buttonClickedSignal subscribeNext:^(id x) {\
    if ([x integerValue] != 0) {\
        [ZYNotificationCenter postNotificationName:NOTIFICATION_GOLOGIN object:nil];\
    }\
}];\
[alertView show];\
return;\
}
#endif
