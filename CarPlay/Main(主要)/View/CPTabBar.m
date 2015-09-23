//
//  CPTabBar.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTabBar.h"

@interface CPTabBar ()
@property (nonatomic, strong) UIButton *plusBtn;
@end

@implementation CPTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setTitle:@"加号" forState:UIControlStateNormal];
        [plusBtn setBackgroundColor:[UIColor yellowColor]];
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

/**
 *  加号按钮点击
 */
- (void)plusClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.plusBtn.width = self.bounds.size.width / 5.0;
    self.plusBtn.height = self.bounds.size.height;
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.bounds.size.width * 0.5;
    self.plusBtn.centerY = self.bounds.size.height * 0.5;
    ;

    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.bounds.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
