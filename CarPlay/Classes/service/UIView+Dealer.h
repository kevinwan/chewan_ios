//
//  UIView+Dealer.h
//  dealer
//
//  Created by GongpingjiaNanjing on 15/6/29.
//  Copyright (c) 2015年 GongpingjiaNanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Dealer)

- (void)alert:(NSString *)message;
// 用于自动提示里面错误信息，如果没有则提示默认错误
- (void)alertError:(id)result;
- (void)alertNetwork;
- (void)showWait;
- (void)hideWait;
- (void)showWaitWithMessage:(NSString *)message;

+ (instancetype)standardSeparateLineWithOrigin:(CGPoint)origin;

+ (instancetype)separateLineViewWithTop:(CGFloat)top left:(CGFloat)left;


@end
