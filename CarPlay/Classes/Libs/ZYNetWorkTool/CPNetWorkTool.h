//
//  CPNetWorkTool.h
//  CarPlay
//
//  Created by chewan on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  自动拼接userid和token,处理用户未登录问题,处理token过期问题

#import "CPNetWorkTool.h"

@interface CPNetWorkTool : NSObject

/**
 *  post请求
 *
 *  @param url     请求URL
 *  @param params  普通的请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  get请求
 *
 *  @param url     请求URL
 *  @param params  普通的请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  json上传
 *
 *  @param url     请求URL
 *  @param params  需要上传的json字典
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postJsonWithUrl:(NSString *)url params:(id)jsonDict success:(void (^)(id responseObject))success failed:(void (^)(NSError *error))failure;

/**
 *  文件上传(可以上传多文件)
 *
 *  @param url     请求URL
 *  @param params  普通的请求参数
 *  @param files   文件参数(里面都是ZYHttpFile模型)
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postFileWithUrl:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
