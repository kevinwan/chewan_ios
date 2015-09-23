//
//  NSFileManager+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ZY)

+ (void)createDirectoryIfNotExistedAtPath:(NSString *)path;
- (void)removeFileAtPath:(NSString *)path condition:(BOOL (^)(NSString *))block;
+ (BOOL)removeItemIfExistsAtPath:(NSString *)path error:(NSError **)error;

@end
