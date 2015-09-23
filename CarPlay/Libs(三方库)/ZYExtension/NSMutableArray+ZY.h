//
//  NSMutableArray+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ZY)

/**
 *  根据过滤规则删除数据
 *
 *  @param predicate 过滤规则
 */
- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

/**
 *  截取指定个数数组
 *
 *  @param maxCount 最大个数
 */
- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount;

/**
 *  替换数组中的元素
 */
- (void)replaceObject:(id)anObject withObject:(id)anotherObject;

#pragma mark - 下面这些插入方法可以避免加入重复数据
- (void)insertUniqueObject:(id)anObject;
- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index;
- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray;
- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray;

@end
