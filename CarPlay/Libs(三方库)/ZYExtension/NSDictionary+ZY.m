//
//  NSDictionary+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "NSDictionary+ZY.h"

@implementation NSDictionary (ZY)

- (NSString *)stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if ((object == nil) || ([object isEqual:[NSNull null]])) {
        return @"";
    }
    if (![object isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", object];
    }
    return object;
}


- (NSDate *)dateForKey:(id)key
{
    NSTimeInterval timeInterval = [self[key] doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}


- (NSInteger)integerForKey:(id)key
{
    id object = self[key];
    if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    return 0;
}


@end
