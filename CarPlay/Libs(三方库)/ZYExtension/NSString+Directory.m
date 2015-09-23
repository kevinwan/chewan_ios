//
//  NSString+Directory.m
//  CarPlay
//
//  Created by chewan on 15/9/10.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "NSString+Directory.h"

@implementation NSString (Directory)

- (NSString *)documentPath
{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    if ([self hasPrefix:@"http://"]) {
        return [document stringByAppendingPathComponent:[self lastPathComponent]];
    }
    return [document stringByAppendingPathComponent:self];
}

- (NSString *)cachePath
{
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    if ([self hasPrefix:@"http://"]) {
        return [cache stringByAppendingPathComponent:[self lastPathComponent]];
    }
    return [cache stringByAppendingPathComponent:self];
}

- (NSString *)tempPath
{
    NSString *temp = NSTemporaryDirectory();
    if ([self hasPrefix:@"http://"]) {
        return [temp stringByAppendingPathComponent:[self lastPathComponent]];
    }
    return [temp stringByAppendingPathComponent:self];
}

@end
