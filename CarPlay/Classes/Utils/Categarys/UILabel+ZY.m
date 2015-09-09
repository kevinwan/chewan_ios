//
//  UILabel+ZY.m
//  测试ilabel
//
//  Created by chewan on 15/8/21.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import "UILabel+ZY.h"

@implementation UILabel (ZY)


+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(NSUInteger)fontSize
{
    UILabel *label = [[self alloc] init];
    label.numberOfLines = 0;
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

/**
 *  如果调用sizeToFit会自动调用此方法
 *
 *  @param size 原有的size
 *
 *  @return 最终的size
 */
- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.numberOfLines) {
        
        return [self textSizeWithMaxW:MAXFLOAT];
        
    }else{

        CGFloat width = self.bounds.size.width;
        
        if (width > 0) {
            
            return [self textSizeWithMaxW:width];
            
        }else{
            if (self.preferredMaxLayoutWidth > 0) {
                return [self textSizeWithMaxW:self.preferredMaxLayoutWidth];
            }else{
                  return [self textSizeWithMaxW:[UIScreen mainScreen].bounds.size.width];
            }
        }
    }
    
}

/**
 *  根据字号计算文本size
 *
 *  @param width label的最大宽度
 *
 *  @return size
 */
- (CGSize)textSizeWithMaxW:(CGFloat)width
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    CGSize size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    size.width += 2;
    size.height += 2;
    
    return size;
}

@end
