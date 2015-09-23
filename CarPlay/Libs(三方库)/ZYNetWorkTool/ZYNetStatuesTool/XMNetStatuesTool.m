//
//  XMNetWorkTool.m
//  小马雅思
//
//  Created by suzhaoyun on 14/12/31.
//  Copyright (c) 2014年 xiaomaguohe. All rights reserved.
//

#import "XMNetStatuesTool.h"

#import "Reachability.h"
@implementation XMNetStatuesTool

+ (XMNetworkStatus) isConnectionAvailable
{
    XMNetworkStatus netWorkStatus;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            netWorkStatus = XMNetworkNotReachable;
            break;
        case ReachableViaWiFi:
            netWorkStatus = XMNetworkWIFI;
            break;
        case ReachableViaWWAN:
            netWorkStatus = XMNetwork3G;
            break;
        default:
            netWorkStatus = XMNetwork2G;
            break;
    }
    
    return netWorkStatus;
}

+ (BOOL)isNoNetWork
{
    return (XMNetworkNotReachable == [self isConnectionAvailable]);
}


+ (BOOL)isWIFI
{
    return XMNetworkWIFI == [self isConnectionAvailable];
}

+ (BOOL)isNetwork3G
{
    return XMNetwork3G == [self isConnectionAvailable];
}

+ (BOOL)isNetwork2G
{
    return XMNetwork2G == [self isConnectionAvailable];
}
@end
