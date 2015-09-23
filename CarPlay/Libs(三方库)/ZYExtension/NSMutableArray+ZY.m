//
//  NSMutableArray+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "NSMutableArray+ZY.h"
#import "NSArray+ZY.h"

@implementation NSMutableArray (ZY)


- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexes];
}


- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount
{
    if ([self count] > maxCount) {
        [self removeObjectsInRange:NSMakeRange(maxCount, [self count] - maxCount)];
    }
}


- (void)replaceObject:(id)anObject withObject:(id)anotherObject
{
    NSInteger index = [self indexOfObject:anObject];
    if (index != NSNotFound) {
        [self replaceObjectAtIndex:index withObject:anotherObject];
    }
}


- (void)insertUniqueObject:(id)anObject
{
    [self insertUniqueObject:anObject atIndex:[self count]];
}


- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index
{
    for (id object in self) {
        if ([object isEqual:anObject]) {
            return;
        }
    }
    if (index < 0 || index > [self count]) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}


- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToInsert = [otherArray arrayByRemovingObjectsFromArray:self];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [objectsToInsert count])];
    [self insertObjects:objectsToInsert atIndexes:indexSet];
}


- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToAppend = [otherArray arrayByRemovingObjectsFromArray:self];
    [self addObjectsFromArray:objectsToAppend];
}

@end
