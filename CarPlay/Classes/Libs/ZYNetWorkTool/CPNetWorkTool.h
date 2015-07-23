//
//  CPNetWorkTool.h
//  CarPlay
//
//  Created by chewan on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

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

// 文件上传所必须的类型
@interface CPHttpFile : NSObject

/** 文件参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件数据 */
@property (nonatomic, strong) NSData *data;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;

/**
 *  快捷创建类型的类方法
 *
 *  @param name     上传到服务器脚本上的字段名
 *  @param data     文件的二进制压缩文件
 *  @param mimeType 文件的小类型
 *  @param filename 上传到服务器保存的文件名
 *
 *  @return httpFile
 */
+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename;

@end
