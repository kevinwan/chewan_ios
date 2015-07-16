//
//  NetworkTools.m
//  
//
//  Created by apple on 15/4/19.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "NetworkTools.h"

@implementation NetworkTools

+ (instancetype)sharedNetworkTools {

    
    static NetworkTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //写网络工具了的创建方法
        //默认测试
        tools = [[NetworkTools alloc]initWithBaseURL:[NSURL URLWithString:@"http://cwapi.gongpingjia.com/v1"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //写网络工具类响应序列化 接收的数据类型
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain" ,nil];
        
    });
    return tools;
}

@end
