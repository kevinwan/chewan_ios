//
//  NSString+activityType.h
//  CarPlay
//
//  Created by chewan on 11/3/15.
//  Copyright © 2015 chewan. All rights reserved.
//  一个过滤活动类型的拓展

#import <Foundation/Foundation.h>

@interface NSString (activityType)

/**
 *  自动添加动词
 */
- (NSString *)type;

/**
 *  自动去除动词
 */
- (NSString *)noType;

@end
