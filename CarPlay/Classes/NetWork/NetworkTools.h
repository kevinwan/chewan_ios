//
//  NetworkTools.h
//
//
//  Created by apple on 15/4/19.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "AFHTTPSessionManager.h"
//工具类继承三方框架
@interface NetworkTools : AFHTTPSessionManager

+ (instancetype)sharedNetworkTools;

@end
