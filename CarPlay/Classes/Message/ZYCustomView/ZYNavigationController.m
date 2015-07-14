//
//  ZYNavigationController.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYNavigationController.h"
#import "ZYNavigationBar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ZYNavigationController ()

@end

@implementation ZYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 利用kvc对readonly的属性进行赋值 自定义navigationBar
    [self setValue:[[ZYNavigationBar alloc] init] forKey:@"navigationBar"];
    
    self.navigationBar.barTintColor = [UIColor greenColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"返回" higImage:nil title:nil target:self action:@selector(back)];
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


@end
