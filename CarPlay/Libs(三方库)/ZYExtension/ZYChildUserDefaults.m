//
//  ZYChildUserDefaults.m
//  封装自用分类
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "ZYChildUserDefaults.h"

@implementation ZYChildUserDefaults

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [super setObject:value forKey:defaultName];
    [self synchronize];
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [super setBool:value forKey:defaultName];
    [self synchronize];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    [super setInteger:value forKey:defaultName];
    [self synchronize];
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    [super setFloat:value forKey:defaultName];
    [self synchronize];
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    [super setDouble:value forKey:defaultName];
    [self synchronize];
}

- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName
{
    [super setURL:url forKey:defaultName];
    [self synchronize];
}

@end
