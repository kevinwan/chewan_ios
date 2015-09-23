//
//  UITabBar+Extension.h
//  CarPlay
//
//  Created by chewan on 15/8/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Extension)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
