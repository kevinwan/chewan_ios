//
//  UIButton+ZY.m
//  测试ilabel
//
//  Created by chewan on 15/8/21.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import "UIButton+ZY.h"
//#import "UIButton+WebCache.h" // 依赖sdwebimage
@implementation UIButton (ZY)

+ (instancetype)buttonWithTitle:(NSString *)title icon:(NSString *)icon titleColor:(UIColor *)color fontSize:(NSUInteger)fontSize
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (icon.length) {
        if ([icon hasPrefix:@"http://"]) {
//            [button sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }else{
            [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        }
    }
    button.titleLabel.textColor = color;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button sizeToFit];
    return button;
    
}

@end
