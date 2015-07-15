//
//  CPHttpTool.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHttpTool : NSObject

+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id jsonObject))success failed:(void (^)(NSError *error))failed;

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(void (^)(id jsonObject))success failed:(void (^)(NSError *error))failed;

@end
