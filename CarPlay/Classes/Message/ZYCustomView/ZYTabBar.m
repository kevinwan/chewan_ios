//
//  ZYTabBar.m
//  CarPlay
//
//  Created by chewan on 15/8/10.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYTabBar.h"

@implementation ZYTabBar

- (void)awakeFromNib
{
    NSLog(@"%@",self.subviews);
    for (UIView *view in self.subviews) {
        DLog(@"%@",view);
    }
}


@end
