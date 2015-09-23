//
//  ZYChildUserDefaults.h
//  封装自用分类
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//  去除每次繁琐的同步操作(synchronize)

#import <Foundation/Foundation.h>

#define ZYUserDefaults [ZYChildUserDefaults standardUserDefaults] // 简化使用

@interface ZYChildUserDefaults : NSUserDefaults

/**
 *  userDefault的设置
 *
 *  @param value       value
 *  @param defaultName key
 */
- (void)setObject:(id)value forKey:(NSString *)defaultName;

@end
