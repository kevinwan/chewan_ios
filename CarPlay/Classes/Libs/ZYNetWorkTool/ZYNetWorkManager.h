//
//  ZYNetWorkManager.h
//  网络请求的基类
//
//  Created by chewan on 15/7/16.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ZYNetWorkManager : AFHTTPRequestOperationManager
+ (instancetype)sharedInstances;
@end
