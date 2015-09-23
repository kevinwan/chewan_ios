//
//  Tools.m
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString *)getUserId
{
    return [ZYUserDefaults stringForKey:UserId];
}

+ (NSString *)getToken
{
    return [ZYUserDefaults stringForKey:Token];
}

+ (BOOL)isLogin
{
    return [self getUserId].length && [self getToken].length;
}

+ (BOOL)isUnLogin
{
    return ![self isLogin];
}

+ (BOOL)isNoNetWork
{
    return [XMNetStatuesTool isNoNetWork];
}

@end
