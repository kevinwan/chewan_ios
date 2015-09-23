//
//  UILabel+ZY.h
//  测试ilabel
//
//  Created by chewan on 15/8/21.
//  Copyright (c) 2015年 chewan. All rights reserved.
//  这是一个可以调用sizeToFit可以自适应高度的label

#import <UIKit/UIKit.h>

@interface UILabel (ZY)

/**
 *  快速创建一个label
 *
 *  @param text     文字
 *  @param color    文字颜色
 *  @param fontSize 字号
 *
 *  @return label
 */

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(NSUInteger)fontSize;

@end
