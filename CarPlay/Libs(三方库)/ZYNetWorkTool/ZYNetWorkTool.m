//
//  ZYNetWorkTool.m
//  轻量级网络工具类
//  Created by chewan on 15/7/16.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "ZYNetWorkTool.h"
#import "AFNetworking.h"
#import "ZYNetWorkManager.h"

#define LoginFrom3Party @"LoginFrom3Party"
@implementation ZYNetWorkTool

+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    if (url.length == 0)return;
    // 1.创建一个请求管理者<单例不必考虑内存问题>
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    // 2.发送一个POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
                [self reLoginWithSuccess:^{
                    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                    mgr.requestSerializer.timeoutInterval = 40;
                    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
                } failed:^(NSError *error) {
                    if (failure) {
                        failure(error);
                    }
                }];
              }
          else{
              if (success) {
                  success(responseObject);
              }
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
              
          }

      }];
}

+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if (url.length == 0)return;
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送一个GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         DLog(@"请求的url为%@",operation.request.URL.absoluteString);
         if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
             
             [self reLoginWithSuccess:^{
                 
                 mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                 mgr.requestSerializer.timeoutInterval = 40;
                 [mgr GET:url parameters:params success:^(AFHTTPRequestOperation * operation, id responseObject) {
                     if (success) {
                         success(responseObject);
                     }
                 } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
             } failed:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
         }else{
             if (success) {
                 success(responseObject);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }

     }];
}

+ (void)postJsonWithUrl:(NSString *)url params:(id)jsonDict success:(void (^)(id responseObject))success failed:(void (^)(NSError *error))failure
{
    if (url.length == 0)return;
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    
    // 请求类型为json
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Accept"];
    
    // 网络超时时长
    mgr.requestSerializer.timeoutInterval = 40;
    
    if (jsonDict == nil) {
        jsonDict = @{};
    }
    
    [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"postJson%@ %@==",operation.request.URL.absoluteString,operation.request.allHTTPHeaderFields);
        if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
            [self reLoginWithSuccess:^{
                // 请求类型为json
                mgr.requestSerializer = [AFJSONRequestSerializer serializer];
                
                mgr.requestSerializer.timeoutInterval = 40;
                [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation * operation, id responseObject) {
                    if (success) {
                        success(responseObject);
                    }
                } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            } failed:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }else{
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postFileWithUrl:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if (url.length == 0)return;
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (ZYHttpFile *file in files) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
            [self reLoginWithSuccess:^{
                
                mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                mgr.requestSerializer.timeoutInterval = 40;
                [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    for (ZYHttpFile *file in files) {
                        [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
                    }
                }success:^(AFHTTPRequestOperation * operation, id responseObject) {
                    if (success) {
                        success(responseObject);
                    }
                } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            } failed:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }else{
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  重新登录的私有方法
 */
+ (void)reLoginWithSuccess:(void (^)())success failed:(failed)failed
{
    DLog(@"token过期了");
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 40;
    
//    BOOL isThirdLogin = [CPUserDefaults boolForKey:LoginFrom3Party];
//    DLog(@"isthirdLogin ---------------------------%zd",isThirdLogin);
//
//    if (isThirdLogin) {
//        NSDictionary *dict = [Tools getValueFromKey:THIRDPARTYLOGINACCOUNT];
//        NSString *urlStr = @"v1/sns/login";
//        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if ([responseObject operationSuccess]) {
//                NSDictionary *data=[responseObject objectForKey:@"data"];
//                [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
//                DLog(@"三方登录复活啦============");
//                if (success) {
//                    success();
//                }
//            }
//
//        } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
//            if (failed) {
//                failed(error);
//            }
//        }];
//        return;
//    }
//    
//    
    // 2. 如果是普通登录
    NSString *phone = [ZYUserDefaults stringForKey:@"phone"];
    NSString *password = [ZYUserDefaults stringForKey:@"password"];

    if (phone.length == 0 || password.length == 0){
        return;
    }
    
    NSString *url = @"user/login";
    [mgr POST:url parameters:@{@"phone" : phone, @"password" : password } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        if (CPSuccess) {
            DLog(@"token过期普通登录修复");
            // 重新设置token
            
            [ZYUserDefaults setObject:[responseObject[@"data"] objectForKey:@"token"] forKey:Token];
            if (success){
                success();
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        if (failed) {
            failed(error);
        }
    }];
}

+ (void)calculateRegisterFrom:(NSString *)url
{
//    if (CPUnLogin) {
//        if (![url isEqualToString:@"v1/user/register"] && ![url isEqualToString:@""]) {
//            [CPUserDefaults setValue:url forKey:@"CPRegisterFrom"];
//            [CPUserDefaults synchronize];
//        }
//    }
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
