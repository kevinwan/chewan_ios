//
//  Tools.h
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (NSString *)getUserId;

+ (NSString *)getToken;

+ (BOOL)isLogin;

+ (BOOL)isUnLogin;

+ (BOOL)isNoNetWork;

@end
