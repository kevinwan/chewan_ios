//
//  NSDictionary+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZY)

- (NSString *)stringForKey:(id)key;
- (NSDate *)dateForKey:(id)key;
- (NSInteger)integerForKey:(id)key;

@end
