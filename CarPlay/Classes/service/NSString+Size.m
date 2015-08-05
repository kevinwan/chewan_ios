//
//  NSString+Size.m
//  CarPlay
//
//  Created by Jia Zhao on 15/7/31.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)
// 实现对象方法
- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

// 类方法
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font
{
    return [text sizeOfTextWithMaxSize:maxSize font:font];
}
@end
