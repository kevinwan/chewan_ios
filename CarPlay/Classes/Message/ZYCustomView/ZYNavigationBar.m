//
//  ZYNavigationBar.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYNavigationBar.h"

@implementation ZYNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        if ([subview isKindOfClass:[UIButton class]] && subview.frame.origin.x < self.frame.size.width * 0.5) {
            subview.x = 10;
        }
    }
}

@end
