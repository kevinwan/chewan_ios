//
//  ZYNetWorkTool.m
//  轻量级网络工具类
//  Created by chewan on 15/7/16.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "ZYNetWorkTool.h"
#import "AFNetworking.h"
#import "ZYNetWorkManager.h"

@implementation ZYNetWorkTool

+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送一个POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送一个GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)postJsonWithUrl:(NSString *)url params:(id)jsonDict success:(void (^)(id responseObject))success failed:(void (^)(NSError *error))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 40;
    [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postFileWithUrl:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (ZYHttpFile *file in files) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

@implementation ZYHttpFile

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    ZYHttpFile *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    file.mimeType = mimeType;
    file.filename = filename;
    return file;
}

@end
