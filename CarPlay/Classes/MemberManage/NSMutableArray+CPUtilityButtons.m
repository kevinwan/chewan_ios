//
//  NSMutableArray+CPUtilityButtons.m
//  CarPlay
//
//  Created by Jia Zhao on 15/8/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "NSMutableArray+CPUtilityButtons.h"
#import <SDWebImage/UIButton+WebCache.h>
/**
 *  设置背景图片和前景图片
 */
@implementation NSMutableArray (CPUtilityButtons)
- (void)sw_addUtilityButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sub = [UIButton buttonWithType:UIButtonTypeCustom];
    sub.tag = 1000;
    sub.userInteractionEnabled = NO;
    //设置初始图片为nil
    [sub setImage:nil forState:UIControlStateNormal];
    [sub setBackgroundImage:[UIImage imageNamed:@"member_seat"] forState:UIControlStateNormal];
    [button layoutIfNeeded];
    sub.size = sub.currentBackgroundImage.size;
    sub.x = button.x;
    sub.y = button.y + 11;
    sub.frame = CGRectMake(sub.x, sub.y, sub.size.width, sub.size.height);
    sub.imageView.layer.cornerRadius = 12;
    [sub clipsToBounds];
    sub.imageEdgeInsets = UIEdgeInsetsMake(-4, 3, 10, 3);
    [button addSubview:sub];
    button.backgroundColor = [UIColor clearColor];

    [self addObject:button];
}


@end
