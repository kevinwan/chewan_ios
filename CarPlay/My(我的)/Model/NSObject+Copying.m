//
//  NSObject+Copying.m
//  CarPlay
//
//  Created by chewan on 10/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "NSObject+Copying.h"

@implementation NSObject (Copying)

- (id)copyFromSelf
{
    Class aClass = [self class];
    NSObject *newObject = [[aClass alloc] init];
    NSArray *allowedCodingPropertyNames = [aClass totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [aClass totalIgnoredCodingPropertyNames];
    
    [aClass enumerateProperties:^(MJProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        
        // 去除只读属性的赋值
        NSString *propertyStr = [NSString stringWithUTF8String:property_getAttributes(property.property)];
        if (![propertyStr rangeOfString:@"R"].length) {
            
            [property setValue:value forObject:newObject];
        }
    }];
    return newObject;
}

@end
