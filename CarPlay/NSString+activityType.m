//
//  NSString+activityType.m
//  CarPlay
//
//  Created by chewan on 11/3/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "NSString+activityType.h"

@implementation NSString (activityType)
- (NSString *)type
{
    return [Tools activityTypeWithString:self];
}
- (NSString *)noType
{
    return [Tools activityNoTypeWithString:self];
}
@end
