//
//  UIButton+ZY.h
//  测试ilabel
//
//  Created by chewan on 15/8/21.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZY)

/**
 *  快速创建按钮的类方法
 *
 *  @param title    标题
 *  @param icon     图片
 *  @param color    文字颜色
 *  @param fontSize 字号
 *
 *  @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title icon:(NSString *)icon titleColor:(UIColor *)color fontSize:(NSUInteger)fontSize;

@end
