//
//  UIViewController+ZYExtension.m
//  CarPlay
//
//  Created by chewan on 15/9/22.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "UIViewController+ZYExtension.h"

#define NavgationItemTitleColor [UIColor blackColor]
#define NavgationItemTitleFont  [UIFont systemFontOfSize:16]

@implementation UIViewController (ZYExtension)

- (void)addSubView:(UIView *)subView
{
    [self.view addSubview:subView];
}

- (UIBarButtonItem *)navigationBarItemWithTitle:(NSString *)title Image:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:NavgationItemTitleColor forState:UIControlStateNormal];
    btn.titleLabel.font = NavgationItemTitleFont;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (imageName.length) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (highImageName.length) {
        [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setLeftNavigationBarItemWithTitle:(NSString *)title Image:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action
{
    if (self.navigationController) {
        self.navigationController.navigationItem.leftBarButtonItem = [self navigationBarItemWithTitle:title Image:imageName highImage:highImageName target:target action:action];
    }else{
        NSLog(@"😁并没有找到导航控制器");
    }
}

- (void)setRightNavigationBarItemWithTitle:(NSString *)title Image:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action
{
    if (self.navigationController) {
        self.navigationController.navigationItem.rightBarButtonItem = [self navigationBarItemWithTitle:title Image:imageName highImage:highImageName target:target action:action];
    }else{
        NSLog(@"😁并没有找到导航控制器");
    }
}

@end
