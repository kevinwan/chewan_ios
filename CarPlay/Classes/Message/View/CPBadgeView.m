//
//  CPBadgeView.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPBadgeView.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"

@implementation CPBadgeView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

// 进行初始化设置
- (void)setUp
{
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    [self setBackgroundImage:[UIImage resizableImage:@"main_badge"] forState:UIControlStateNormal];
    // 按钮的高度就是背景图片的高度
    self.height = self.currentBackgroundImage.size.height;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    // 设置文字
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    // 根据文字计算自己的尺寸
    CGSize titleSize = [badgeValue sizeWithFont:self.titleLabel.font];
    CGFloat bgW = self.currentBackgroundImage.size.width;
    if (titleSize.width < bgW) {
        self.width = bgW;
    } else {
        self.width = titleSize.width + 10;
    }
}

@end
