//
//  ZYNetWorkTool.m
//  轻量级网络工具类
//  Created by chewan on 15/7/16.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "ZYNetWorkTool.h"
#import "AFNetworking.h"
#import "ZYNetWorkManager.h"
#import "CPMySubscribeModel.h"
#define LoginFrom3Party @"LoginFrom3Party"
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
    // 1.创建一个请求管理者
    ZYNetWorkManager *mgr = [ZYNetWorkManager sharedInstances];
    
    // 请求类型为json
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 网络超时时长
    mgr.requestSerializer.timeoutInterval = 40;
    
    [mgr POST:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    BOOL isThirdLogin = [CPUserDefaults boolForKey:LoginFrom3Party];
    DLog(@"isthirdLogin%zd",isThirdLogin);

    if (isThirdLogin) {
        NSDictionary *dict = [Tools getValueFromKey:THIRDPARTYLOGINACCOUNT];
        NSString *urlStr = @"v1/sns/login";
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject operationSuccess]) {
                DLog(@"token过期三方登陆修复");
                NSDictionary *data=[responseObject objectForKey:@"data"];
                if ([data objectForKey:@"userId"]) {
                    //这里要处理环信登录
                    EMError *error = nil;
                    NSString *EMuser=[Tools md5EncryptWithString:[data objectForKey:@"userId"]];
                    NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:dict[@"sign"] error:&error];
                    if (!error && loginInfo) {
                        [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
                        [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
                        [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
                        
                        CPOrganizer *organizer= [CPOrganizer objectWithKeyValues:data];
                        NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];
                        [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                        
                        [Tools setValueForKey:dict key:THIRDPARTYLOGINACCOUNT];
                        [Tools setValueForKey:@(YES) key:@"LoginFrom3Party"];
                        if (success) {
                            success();
                        }
                    }
                }
                
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
            if (failed) {
                failed(error);
            }
        }];
    }
    
    
    // 2. 如果是普通登录
    NSString *phone = [Tools getValueFromKey:@"phone"];
    NSString *password = [Tools getValueFromKey:@"password"];

    NSString *url = @"v1/user/login";
    [mgr POST:url parameters:@{@"phone" : phone, @"password" : password } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        if (CPSuccess) {
            DLog(@"token过期普通登录修复");
            // 重新设置token
            [Tools setValueForKey:[responseObject[@"data"] objectForKey:@"token"] key:@"token"];
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
