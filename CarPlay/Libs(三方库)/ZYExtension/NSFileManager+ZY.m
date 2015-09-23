//
//  NSFileManager+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "NSFileManager+ZY.h"

@implementation NSFileManager (ZY)

+ (void)createDirectoryIfNotExistedAtPath:(NSString *)path
{
    BOOL isDirectory = NO;
    BOOL exists = [[self defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (exists) {
        if (isDirectory) {
            return;
        }
        [[self defaultManager] removeItemAtPath:path error:nil];
    }
    
    [[self defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}


- (void)removeFileAtPath:(NSString *)path condition:(BOOL (^)(NSString *))block
{
    NSArray *files = [self contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filePath in files) {
        NSString *fullPath = [path stringByAppendingPathComponent:filePath];
        if (block(fullPath)) {
            [self removeItemAtPath:fullPath error:nil];
        }
    }
}


+ (BOOL)removeItemIfExistsAtPath:(NSString *)path error:(NSError **)error
{
    BOOL result = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        result = [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    }
    return result;
}


@end
