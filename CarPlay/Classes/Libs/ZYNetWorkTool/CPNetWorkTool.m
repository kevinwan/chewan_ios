//
//  CPNetWorkTool.m
//  CarPlay
//
//  Created by chewan on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNetWorkTool.h"
#import "ZYNetWorkManager.h"
#import "ZYNetWorkTool.h"

@implementation CPNetWorkTool
+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (userId.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *token = [Tools getValueFromKey:@"token"];
    if (token.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *userStr = [NSString stringWithFormat:@"?userId=%@&token=%@",userId, token];
    
    url = [url stringByAppendingString:userStr];
    
    // 2.发送一个POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if ([error.localizedDescription contains:@"口令已过期"]){
              // 重新发出登录请求
              NSString *phone = [Tools getValueFromKey:@"phone"];
              NSString *password = [Tools getValueFromKey:@"password"];
              [ZYNetWorkTool postWithUrl:@"v1/user/login" params:@{@"phone" : phone, @"password" : password} success:^(id responseObject) {
                  if (CPSuccess) {
                       [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                      [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if (success) {
                              success(responseObject);
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (failure) {
                              failure(error);
                          }
                      }];
                  }
                  
              } failure:^(NSError *error) {
                  if (failure) {
                      failure(error);
                  }
              }];
              
          }else if (failure) {
              failure(error);
          }
      }];
}

+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (userId.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *token = [Tools getValueFromKey:@"token"];
    if (token.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *userStr = [NSString stringWithFormat:@"?userId=%@&token=%@",userId, token];
    
    url = [url stringByAppendingString:userStr];
    // 2.发送一个GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([error.localizedDescription contains:@"口令已过期"]){
             // 重新发出登录请求
             NSString *phone = [Tools getValueFromKey:@"phone"];
             NSString *password = [Tools getValueFromKey:@"password"];
             [ZYNetWorkTool postWithUrl:@"v1/user/login" params:@{@"phone" : phone, @"password" : password} success:^(id responseObject) {
                 if (CPSuccess) {
                     [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                     [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (success) {
                             success(responseObject);
                         }
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
                 }
                 
             } failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
             
         }else if (failure) {
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
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (userId.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *token = [Tools getValueFromKey:@"token"];
    if (token.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *userStr = [NSString stringWithFormat:@"?userId=%@&token=%@",userId, token];
    
    url = [url stringByAppendingString:userStr];
    [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([error.localizedDescription contains:@"口令已过期"]){
            // 重新发出登录请求
            NSString *phone = [Tools getValueFromKey:@"phone"];
            NSString *password = [Tools getValueFromKey:@"password"];
            [ZYNetWorkTool postWithUrl:@"v1/user/login" params:@{@"phone" : phone, @"password" : password} success:^(id responseObject) {
                if (CPSuccess) {
                    [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
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
                
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }else if (failure) {
            failure(error);
        }
    }];
}

+ (void)postFileWithUrl:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    mgr.requestSerializer.timeoutInterval = 40;
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (userId.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *token = [Tools getValueFromKey:@"token"];
    if (token.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    NSString *userStr = [NSString stringWithFormat:@"?userId=%@&token=%@",userId, token];
    
    url = [url stringByAppendingString:userStr];
    
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
        if ([error.localizedDescription contains:@"口令已过期"]){
            // 重新发出登录请求
            NSString *phone = [Tools getValueFromKey:@"phone"];
            NSString *password = [Tools getValueFromKey:@"password"];
            [ZYNetWorkTool postWithUrl:@"v1/user/login" params:@{@"phone" : phone, @"password" : password} success:^(id responseObject) {
                if (CPSuccess) {
                    [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
                    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        for (ZYHttpFile *file in files) {
                            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
                        }
                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
                }
                
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }else if (failure) {
            failure(error);
        }
    }];
}

@end

@implementation CPHttpFile

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    CPHttpFile *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    file.mimeType = mimeType;
    file.filename = filename;
    return file;
}

@end
