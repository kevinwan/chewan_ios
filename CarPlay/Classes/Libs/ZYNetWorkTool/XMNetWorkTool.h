//
//  XMNetWorkTool.h
//  小马雅思
//
//  Created by suzhaoyun on 14/12/31.
//  Copyright (c) 2014年 xiaomaguohe. All rights reserved.
//

#import <Foundation/Foundation.h>
/** network types */
typedef enum XMNetworkStatus {
    XMNetworkNotReachable = 0,
    XMNetwork2G,
    XMNetwork3G,
    XMNetworkWIFI,
} XMNetworkStatus;

@interface XMNetWorkTool : NSObject
/**
 *  获取当前的网络状态
 */
+ (XMNetworkStatus) isConnectionAvailable;

/**
 *  网络是否可用
 */
+ (BOOL)isReachable;
/**
 *  是不是WIFI
 */
+ (BOOL)isWIFI;

/**
 *  是不是3G
 */
+ (BOOL)isNetwork3G;
/**
 *  是不是2g网络
 */
+ (BOOL)isNetwork2G;

@end
