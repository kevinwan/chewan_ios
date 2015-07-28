//
//  NSDictionary+Dealer.m
//  dealer
//
//  Created by GongpingjiaNanjing on 15/6/30.
//  Copyright (c) 2015年 GongpingjiaNanjing. All rights reserved.
//

#import "NSDictionary+Dealer.h"

@implementation NSDictionary (Dealer)

- (BOOL)operationSuccess
{
    
    
    return [[self stringForKey:@"result"] isEqualToString:@"0"];
}

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
@end
