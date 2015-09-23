//
//  CPTabBarController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPTabBar.h"
#import "CPNavigationController.h"
#import "CPNearViewController.h"

@interface CPTabBarController () <CPTabBarDelegate>

@end

@implementation CPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    // 1.初始化子控制器
    
    CPNearViewController *nearVc1 = [[CPNearViewController alloc] init];
    [self addChildVc:nearVc1 title:@"附近" image:@"" selectedImage:@""];
    
    CPNearViewController *nearVc2 = [[CPNearViewController alloc] init];
    [self addChildVc:nearVc2 title:@"首sgsd页" image:@"" selectedImage:@""];
    
    CPNearViewController *nearVc3 = [[CPNearViewController alloc] init];
    [self addChildVc:nearVc3 title:@"首fs页" image:@"" selectedImage:@""];
    
    CPNearViewController *nearVc4 = [[CPNearViewController alloc] init];
    nearVc4.view.backgroundColor = [UIColor blueColor];
    [self addChildVc:nearVc4 title:@"首ss页" image:@"" selectedImage:@""];

    // 2.更换系统自带的tabbar
    CPTabBar *tabBar = [[CPTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
 
}


/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = ZYColor(123, 123, 123, 1);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    CPNavigationController *nav = [[CPNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark - CPTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(CPTabBar *)tabBar
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
