//
//  UIViewController+ZYExtension.h
//  CarPlay
//
//  Created by chewan on 15/9/22.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZYExtension)

- (void)addSubView:(UIView *)subView;

/**
 *  设置导航栏左侧按钮
 */
- (void)setLeftNavigationBarItemWithTitle:(NSString *)title Image:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action;

/**
 *  设置导航栏右侧按钮
 */
- (void)setRightNavigationBarItemWithTitle:(NSString *)title Image:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action;
@end
