//
//  NSArray+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZY)

/**
 *  规避数组越界问题
 *
 *  @return 如果越界 return nil
 */
- (id)firstObject;

/**
 *  规避数组越界问题
 *
 *  @return 如果越界 return nil
 */
- (id)lastObject;

/**
 *  进行元素的过滤
 *
 *  @param predicate 过滤规则
 *
 *  @return 过滤后的结果
 */
- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

/**
 *  删除指定类型的数据
 *
 *  @param aClass 类型
 *
 *  @return 过滤后的结果
 */
- (NSArray *)arrayByRemovingObjectsOfClass:(Class)aClass;

/**
 *  只保留指定的结果
 *
 *  @param aClass 类型
 *
 *  @return 过滤后的结果
 */
- (NSArray *)arrayByKeepingObjectsOfClass:(Class)aClass;

/**
 *  删除和另外一个数组相同的元素
 *
 *  @param otherArray array
 *
 *  @return 过滤后的结果
 */
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)otherArray;

- (NSArray *)transformedArrayUsingHandler:(id (^)(id originalObject, NSUInteger index))handler;

/**
 *  数组的range
 */
- (NSRange)fullRange;

@end
