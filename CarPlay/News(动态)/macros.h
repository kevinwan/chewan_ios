//
//  macros.h
//  EaseMob
//
//  Created by Ji Fang on 3/8/13.
//  Copyright (c) 2013 Ji Fang. All rights reserved.
//
//#import "XDDefine.h"
#ifndef EaseMob_macros_h
#define EaseMob_macros_h


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//三原色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//设备的高度、宽度
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

//用户昵称和头像的存储
#define kUserNickName @"kUserNickName"
#define kUserHeadUrl @"kUserHeadUrl"
#define kUserAge @"kUserAge"
#define KUserSex @"KUserSex"
//发送语音通话时，接收方的头像和昵称
#define kReceiverHeadUrl @"kReceiverHeadUrl"
#define kReceiverNickName @"kReceiverNickName"

#define kSendCallHeadURL @"kSendCallHeadURL"
#define kSendCallNickName @"kSendCallNickName"

//第一次运行app的提示，版本升级的不算，第一次的在动态加个小红点
#define First_install_app @"First_install_app"

typedef enum _BasicViewControllerInfo {
    eBasicControllerInfo_Title,
    eBasicControllerInfo_ImageName,
    eBasicControllerInfo_BadgeString
}BasicViewControllerInfo;



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
//////

#endif



