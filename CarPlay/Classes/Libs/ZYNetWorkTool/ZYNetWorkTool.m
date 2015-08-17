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
    // 1.创建一个请求管理者<单例不必考虑内存问题>
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送一个POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
              // 重新发出登录请求
              NSString *phone = [Tools getValueFromKey:@"phone"];
              NSString *password = [Tools getValueFromKey:@"password"];
              mgr.requestSerializer = [AFJSONRequestSerializer serializer];
              NSString *url = [BASE_URL stringByAppendingString:@"v1/user/login"];
              [mgr POST:url parameters:@{@"phone" : phone, @"password" : password } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (CPSuccess) {
                      // 重新设置token
                      [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                      mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                      
                      [mgr POST:url parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject)  {
                            if (success) {
                                success(responseObject);
                            }
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if (failure) {
                                failure(error);
                            }
                        }];
                      
                  }
                  else{
                      if (failure) {
                          [SVProgressHUD dismiss];
                          failure([NSError errorWithDomain:@"登录失败" code:111 userInfo:nil]);
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    // 2.发送一个GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
             // 重新发出登录请求
             NSString *phone = [Tools getValueFromKey:@"phone"];
             NSString *password = [Tools getValueFromKey:@"password"];
             mgr.requestSerializer = [AFJSONRequestSerializer serializer];
             NSString *url = [BASE_URL stringByAppendingString:@"v1/user/login"];
             [mgr POST:url parameters:@{@"phone" : phone, @"password" : password } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (CPSuccess) {
                     // 重新设置token
                     [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                     mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                     
                     [mgr GET:url parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if (success) {
                              success(responseObject);
                          }
                      }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (failure) {
                              failure(error);
                          }
                      }];
                     
                 }
                 else{
                     if (failure) {
                         [SVProgressHUD dismiss];
                         failure([NSError errorWithDomain:@"登录失败" code:111 userInfo:nil]);
                     }
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    
    // 请求类型为json
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 网络超时时长
    mgr.requestSerializer.timeoutInterval = 40;
    
    [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"result"] intValue] && [responseObject[@"errmsg"] contains:@"口令已过期"]) {
            // 重新发出登录请求
            NSString *phone = [Tools getValueFromKey:@"phone"];
            NSString *password = [Tools getValueFromKey:@"password"];
            mgr.requestSerializer = [AFJSONRequestSerializer serializer];
            NSString *url = [BASE_URL stringByAppendingString:@"v1/user/login"];
            [mgr POST:url parameters:@{@"phone" : phone, @"password" : password } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (CPSuccess) {
                    // 重新设置token
                    [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
                    
                    [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
                    
                }
                else{
                    if (failure) {
                        [SVProgressHUD dismiss];
                        failure([NSError errorWithDomain:@"登录失败" code:111 userInfo:nil]);
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
            // 重新发出登录请求
            NSString *phone = [Tools getValueFromKey:@"phone"];
            NSString *password = [Tools getValueFromKey:@"password"];
            mgr.requestSerializer = [AFJSONRequestSerializer serializer];
            NSString *url = [BASE_URL stringByAppendingString:@"v1/user/login"];
            [mgr POST:url parameters:@{@"phone" : phone, @"password" : password } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (CPSuccess) {
                    // 重新设置token
                    [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                    
                    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        for (ZYHttpFile *file in files) {
                            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
                        }
                    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
                }
                else{
                    if (failure) {
                        [SVProgressHUD dismiss];
                        failure([NSError errorWithDomain:@"登录失败" code:111 userInfo:nil]);
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
