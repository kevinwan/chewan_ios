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
#import "CPMyViewController.h"
#import "CPMyCareController.h"
#import "CPTestPhotoViewController.h"
@interface CPTabBarController () <CPTabBarDelegate>

@end

@implementation CPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.初始化子控制器
    
    CPNearViewController *nearVc1 = [[CPNearViewController alloc] init];
    [self addChildVc:nearVc1 title:@"附近" image:@"" selectedImage:@""];
    
    CPTestPhotoViewController *nearVc2 = [[CPTestPhotoViewController alloc] init];
    [self addChildVc:nearVc2 title:@"推荐" image:@"" selectedImage:@""];
    
    CPMyCareController *vc3 = [UIStoryboard storyboardWithName:@"CPMyCareController" bundle:nil].instantiateInitialViewController;
    [self addChildVc:vc3 title:@"我的关注" image:@"" selectedImage:@""];
    
    CPMyViewController *nearVc4 = [UIStoryboard storyboardWithName:@"CPMyViewController" bundle:nil].instantiateInitialViewController;
    [self addChildVc:nearVc4 title:@"我的" image:@"" selectedImage:@""];

    // 2.更换系统自带的tabbar
    CPTabBar *tabBar = [[CPTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    [self.tabBar setTintColor:RedColor];
    
    UITabBarItem *itemApp = [UITabBarItem appearance];
    [itemApp setTitleTextAttributes:@{NSFontAttributeName : ZYFont12} forState:UIControlStateNormal];
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
//
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
