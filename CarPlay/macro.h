//
//  macro.h
//
//  Created by 牛鹏赛 on 15-7-8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface macro : NSObject

#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//接口地址
#define BASE_URL @"http://cwapi.gongpingjia.com:80/"

//测试接口地址
#define TEST_URL @"http://api.bbh.sunprosp.com"

//单例
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]   //当前设备的系统版本
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      //屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //屏幕高度

#define WANCHE_NAVIGATIONBAR_BACKGROUND_IMAGE @"navigationBarBg"

//#define COLOR_NAV_BAR RGBACOLOR(36, 31, 37, 1)
#define  COLOR_NAV_BAR  [Tools getColor:@"312a32"]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR(A, B, C)        [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


//正则表达式
#define MOBILE @"^1(3[0-9]|5[0-35-9]|8[01235-9])\\d{8}$"

//字体
#define UNI_FONT_SIZE_13 ([UIFont systemFontOfSize:13]);
#define UNI_FONT_SIZE_BOLD_13 ([UIFont boldSystemFontOfSize:13]);
#define UNI_FONT_SIZE_15 ([UIFont systemFontOfSize:15]);
#define UNI_FONT_SIZE_BOLD_15 ([UIFont boldSystemFontOfSize:15]);
#define UNI_FONT_SIZE_18 ([UIFont systemFontOfSize:18]);
#define UNI_FONT_SIZE_BOLD_18 ([UIFont boldSystemFontOfSize:18]);
#define UNI_FONT_SIZE_22 ([UIFont systemFontOfSize:22]);
#define UNI_FONT_SIZE_BOLD_22 ([UIFont boldSystemFontOfSize:22]);

#define PLACEHOLDERIMAGE @""
//整体色调

//路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//==============================DLog/NSLog=====================
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif

//==============================KeyChain=====================

#define UNI_USERDEFAULT_FIRSTOPEN @"cp_firstopen"

#define WANCHE_USERDEFAULT_USERID @"userid"
#define WANCHE_USERDEFAULT_USERTOKEN @"token"
#define WANCHE_USERDEFAULT_USERNAME @"username"
#define WANCHE_USERDEFAULT_USERICON @"usericon"
#define WANCHE_USERDEFAULT_HASLOGIN @"haslogin"


//******************************************************

//登陆状态改变
#define NOTIFICATION_LOGINCHANGE @"loginStatusChange"
#define NOTIFICATION_ROOTCONTROLLERCHANGETOTAB @"rootControllerChangeToTab"
#define NOTIFICATION_HASLOGIN @"hasLogin"
#define THIRDPARTYLOGINACCOUNT @"3partyLoginAccount"

//宏定义属性
#define Property(s) @property (nonatomic,copy)NSString *s




typedef enum _BasicViewControllerInfo {
    eBasicControllerInfo_Title,
    eBasicControllerInfo_ImageName,
    eBasicControllerInfo_BadgeString
}BasicViewControllerInfo;
#define CPIsLogin ([Tools cpIsLogin]) // 是否登录成功
#define CPUnLogin (![Tools cpIsLogin]) // 是否登录成功
#define CPSuccess ([responseObject[@"result"] intValue] == 0)
#define CPFailure ([responseObject[@"result"] intValue] == 1)
#define ZYJumpToLoginView \
if (CPUnLogin) {\
    [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];\
    return;\
}
#pragma mark - runtime macros
// check if runs on iPad
#define IS_IPAD_RUNTIME (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// version check
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedDescending)

#define NTF_WILLSENDMESSAGETOJID                @"NTF_WILLSENDMESSAGETOJID"
#define WILLSENDMESSAGETOJID                    @"WILLSENDMESSAGETOJID"
#define WILLSENDMESSAGETOJID_CHATROOMMESSAGE    @"WILLSENDMESSAGETOJID_CHATROOMMESSAGE"
#define WILLSENDMESSAGETOJID_CHATDATA           @"WILLSENDMESSAGETOJID_CHATDATA"

#define NTF_FINISHED_LOAD_DATA_FROM_DB  @"NTF_FINISHED_LOAD_DATA_FROM_DB"

// used in settings.
typedef enum _playSoundMode {
    ePlaySoundMode_AutoDetect,
    ePlaySoundMode_Speaker,
    ePlaySoundMode_Handset
}PlaySoundMode;

// exception macros
#define NOT_IMPLEMENTED_EXCEPTION   @"NOT_IMPLEMENTED_EXCEPTION"
#define CPNetWorkStatus @"CPNetWorkStatus"
#define CPNoNetWork ([CPUserDefaults boolForKey:CPNetWorkStatus])
#define CPReRefreshNotification @"CPReRefreshNotification"
#define CPClickUserIconNotification @"CPClickUserIconNotification"
#define CPClickUserIconInfo @"CPClickUserIconInfo"
#define CPPageNum 10
@end
