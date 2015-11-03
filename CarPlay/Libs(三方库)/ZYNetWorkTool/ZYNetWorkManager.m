//
//  ZYNetWorkManager.m
//  网络请求的基类
//
//  Created by chewan on 15/7/16.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "ZYNetWorkManager.h"

@implementation ZYNetWorkManager

+ (instancetype)sharedInstances
{
    static ZYNetWorkManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
        // 扩展AFN接受的数据类型
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    
    // 防止上传完json数据不能加载普通请求
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    return _manager;
}

@end
