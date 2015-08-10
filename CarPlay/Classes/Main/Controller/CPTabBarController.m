//
//  CPTabBarController.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPCityController.h"
#import "CPMessageController.h"
#import "CPMyController.h"

@interface CPTabBarController ()

@end

@implementation CPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 同城
    [self addChildVCWithSBName:@"CPCityController" title:@"同城" norImageName:@"同城" selectedImageName:@"同城选中"];
    // 消息
    [self addChildVCWithSBName:@"CPMessageController" title:@"消息" norImageName:@"消息" selectedImageName:@"消息选中"];
    
    // 我的
    [self addChildVCWithSBName:@"CPMyController" title:@"我的" norImageName:@"我的" selectedImageName:@"我的选中"];
}

- (void)addChildVCWithClass:(Class)class title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{
    UIViewController *vc4 = [[class alloc] init];
    [self addChildVCWithController:vc4 title:title norImageName:norImageName selectedImageName:selectedImageName];
}

- (void)addChildVCWithSBName:(NSString *)sbName  title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{
    // 1.加载Storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    // 2.创建Storyboard中的初始控制器
    UINavigationController *nav = sb.instantiateInitialViewController;
    // 3.调用addChildVCWithController
    [self addChildVCWithController:nav.topViewController title:title norImageName:norImageName selectedImageName:selectedImageName];
}

- (void)addChildVCWithController:(UIViewController *)vc  title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{
    
    // 设置标题
    vc.tabBarItem.title = title;
    vc.navigationItem.title = title;
    // 设置默认图片
    vc.tabBarItem.image = [UIImage imageNamed:norImageName];
    // 设置选中图片
    UIImage *selectedImage =  [UIImage imageNamed:selectedImageName];
    // 不渲染图片
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = selectedImage;
    //设置tabBar标题颜色 也可在storyboard中设置
    self.tabBar.tintColor = [Tools getColor:@"48d1d5"];
    
    // 设置随机色
//    vc.view.backgroundColor = CPRandomColor;
    // 添加到父控件
    [self addChildViewController:vc.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
