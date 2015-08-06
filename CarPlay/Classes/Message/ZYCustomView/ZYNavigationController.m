//
//  ZYNavigationController.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYNavigationController.h"
#import "ZYNavigationBar.h"

@interface ZYNavigationController ()

@end

@implementation ZYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 利用kvc对readonly的属性进行赋值 自定义navigationBar
    [self setValue:[[ZYNavigationBar alloc] init] forKey:@"navigationBar"];
    
    self.navigationBar.barTintColor = [Tools getColor:@"48d1d5"];
    
    // 设置全局的导航栏字体
    UINavigationBar *bar = [UINavigationBar appearance];
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:textAttr];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"返回" higImage:nil title:nil target:self action:@selector(back)];
    
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
