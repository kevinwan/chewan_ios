//
//  CPNavigationController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNavigationController.h"

@interface CPNavigationController ()

@end

@implementation CPNavigationController

+ (void)initialize
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{   NSFontAttributeName : ZYFont16,
        NSForegroundColorAttributeName:[UIColor blackColor]}forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 利用kvc对readonly的属性进行赋值 自定义navigationBar
//    [self setValue:[[ZYNavigationBar alloc] init] forKey:@"navigationBar"];
    
    self.navigationBar.barTintColor = [UIColor whiteColor];

    // 隐藏导航栏边框
    UIView *backGroundView = self.navigationBar.subviews.firstObject;
    for (UIView *view in backGroundView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    
    // 设置全局的导航栏字体
    UINavigationBar *bar = [UINavigationBar appearance];
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName] = [Tools getColor:@"333333"];
    textAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:textAttr];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (self.viewControllers.count) {
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"icon_jt" higImage:nil title:nil target:self action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

// 开启ios自带右滑返回
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
@end
