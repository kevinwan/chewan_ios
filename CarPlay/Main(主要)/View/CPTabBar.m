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

- (UIButton *)plusBtn
{
    if (_plusBtn == nil) {
        _plusBtn = [[UIButton alloc] init];
        [_plusBtn setImage:[UIImage imageNamed:@"Wheel"] forState:UIControlStateNormal];
        [_plusBtn setBackgroundColor:[UIColor clearColor]];
        CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:@"transform"];
        anima.duration=0.8;
        anima.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1)];
        anima.removedOnCompletion=NO;
        anima.fillMode=kCAFillModeForwards;
        anima.repeatCount = MAXFLOAT;
        [_plusBtn.layer addAnimation:anima forKey:nil];
        [_plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
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
    
    // 延迟加载加号按钮
    _plusBtn?:[self addSubview:self.plusBtn];
    
    self.plusBtn.width = self.bounds.size.width / 5.0;
    self.plusBtn.height = self.bounds.size.width / 5.0;
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.bounds.size.width * 0.5;
    self.plusBtn.centerY = self.bounds.size.height * 0.5 - 10;
    ;

    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.bounds.size.width / 5.0;
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
