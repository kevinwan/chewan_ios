//
//  CPNetWorkTool.m
//  CarPlay
//
//  Created by chewan on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNetWorkTool.h"
#import "ZYNetWorkTool.h"

@implementation CPNetWorkTool

+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [ZYNetWorkTool postWithUrl:[self dealUserIdTokenWithUrl:url] params:params success:success failure:failure];
}

+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [ZYNetWorkTool getWithUrl:[self dealUserIdTokenWithUrl:url] params:params success:success failure:failure];
}

+ (void)postJsonWithUrl:(NSString *)url params:(id)jsonDict success:(void (^)(id responseObject))success failed:(void (^)(NSError *error))failure
{
    [ZYNetWorkTool postJsonWithUrl:[self dealUserIdTokenWithUrl:url] params:jsonDict success:success failed:failure];
}

+ (void)postFileWithUrl:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [ZYNetWorkTool postFileWithUrl:[self dealUserIdTokenWithUrl:url] params:params files:files success:success failure:failure];
}

/**
 *  自动对URL拼接userId和token,并处理未登录的情况
 *
 *  @param url URL
 *
 *  @return 拼接之后的URL
 */
+ (NSString *)dealUserIdTokenWithUrl:(NSString *)url
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (userId.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        [SVProgressHUD dismiss];
        return nil;
    }
    NSString *token = [Tools getValueFromKey:@"token"];
    if (token.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        [SVProgressHUD dismiss];
        return nil;
    }
    NSString *userStr = [NSString stringWithFormat:@"?userId=%@&token=%@",userId, token];
    
    return [url stringByAppendingString:userStr];

}

@end
