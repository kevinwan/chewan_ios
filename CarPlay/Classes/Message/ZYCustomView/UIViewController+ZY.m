//
//  UIViewController+ZY.m
//  CarPlay
//
//  Created by chewan on 15/7/29.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "UIViewController+ZY.h"

@implementation UIViewController (ZY)
//
//#pragma mark - 设置全局无网络无数据提示界面机制
//
//static UIView *tipView;
//
///**
// *  类第一次加载时才会被调用,但是无法获取屏幕的宽度
// */
//+ (void)load
//{
//    tipView = [[UIView alloc] init];
//    tipView.hidden = YES;
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"网"]];
//    imageView.tag = 1;
//    [tipView addSubview:imageView];
//    tipView.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *tipLabel = [[UILabel alloc] init];
//    tipLabel.text = @"网络错误";
//    tipLabel.tag = 2;
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    [tipView addSubview:tipLabel];
//    tipLabel.font = [UIFont systemFontOfSize:15];
//    
//    UILabel *subTipLabel = [[UILabel alloc] init];
//    subTipLabel.text = @"当前网络不可用,请检查网络哦~";
//    subTipLabel.tag = 3;
//    subTipLabel.textAlignment = NSTextAlignmentCenter;
//    [tipView addSubview:subTipLabel];
//    subTipLabel.font = [UIFont systemFontOfSize:12];
//    subTipLabel.textColor = [Tools getColor:@"aab2bd"];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.tag = 4;
//    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[Tools getColor:@"48d1d5"]];
//    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [tipView addSubview:btn];
//}
//
//- (UIView *)tipView
//{
//    tipView.frame = self.view.bounds;
//    UIView *imgView = [tipView viewWithTag:1];
//    imgView.centerX = tipView.centerXInSelf;
//    imgView.centerY = tipView.centerYInSelf;
//    
//    UIView *titleView = [tipView viewWithTag:2];
//    titleView.x = 0;
//    titleView.y = imgView.bottom + 20;
//    titleView.width = kScreenWidth;
//    titleView.height = 20;
//    
//    UIView *subTipLabel = [tipView viewWithTag:3];
//    subTipLabel.x = 0;
//    subTipLabel.y = titleView.bottom + 10;
//    subTipLabel.width = kScreenWidth;
//    subTipLabel.height = 20;
//    
//    UIButton *btn = (UIButton *)[tipView viewWithTag:4];
//    [btn addTarget:self action:@selector(reRefresh) forControlEvents:UIControlEventTouchDragInside];
//    btn.width = 160;
//    btn.height = 40;
//    btn.centerX = kScreenWidth * 0.5;
//    btn.y = subTipLabel.bottom + 20;
//    btn.layer.cornerRadius = 3;
//    btn.clipsToBounds = YES;
//    
//    return tipView;
//}
//
//- (void)showNoData
//{
//    [self tipViewWithIcon:@"暂无参与" title:@"暂时没有任何数据" subTitle:@"刷新一下试试吧"];
//    tipView.hidden = NO;
////    [self.navigationController.view insertSubview:[self tipViewWithIcon:@"暂无参与" title:@"暂时没有任何数据" subTitle:@"刷新一下试试吧"] belowSubview:self.navigationController.navigationBar];
//}
//
//- (void)showNoPublish
//{
//    [self tipViewWithIcon:@"暂无发布" title:@"暂时没有任何发布" subTitle:@"赶紧去添加发布吧"];
//    tipView.hidden = NO;
//}
//
//- (void)showNoSubscribe
//{
//    [self tipViewWithIcon:@"暂无关注" title:@"暂时没有任何关注" subTitle:@"赶紧去关注吧"];
//    tipView.hidden = NO;
////    [self.navigationController.view insertSubview:[self tipViewWithIcon:@"暂无关注" title:@"暂时没有任何关注" subTitle:@"赶紧去关注吧"] belowSubview:self.navigationController.navigationBar];
//}
//
//- (void)showNoJoin
//{
//    [self tipViewWithIcon:@"暂无参与" title:@"暂时没有任何参与" subTitle:@"赶紧去参与吧"];
//    tipView.hidden = NO;
////    [self.navigationController.view insertSubview:[self tipViewWithIcon:@"暂无参与" title:@"暂时没有任何参与" subTitle:@"赶紧去参与吧"] belowSubview:self.navigationController.navigationBar];
//}
//
///**
// *  设置提示信息
// *
// *  @param title    标题
// *  @param subTitle 子标题
// */
//- (UIView *)tipViewWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle
//{
//    UIImageView *imageView = (UIImageView *)[tipView viewWithTag:1];
//    imageView.image = [UIImage imageNamed:icon];
//    
//    UILabel *tipLabel = (UILabel *)[tipView viewWithTag:2];
//    tipLabel.text = title;
//    
//    UILabel *subTipLabel = (UILabel *)[tipView viewWithTag:3];
//    subTipLabel.text = subTitle;
//    
//    return [self tipView];
//}
#pragma mark - toast提示的方法
- (void)showLoading
{
    [SVProgressHUD showWithStatus:@"努力加载中"];
}

- (void)showLoadingWithInfo:(NSString *)info
{
    if (info.length) {
        [SVProgressHUD showWithStatus:info];
    }else{
        [self showLoading];
    }
}

- (void)showInfo:(NSString *)info
{
    [SVProgressHUD showInfoWithStatus:info];
}

- (void)showError:(NSString *)error
{
    [SVProgressHUD showErrorWithStatus:error];
}

- (void)showSuccess:(NSString *)success
{
    [SVProgressHUD showSuccessWithStatus:success];
}

- (void)disMiss
{
    [SVProgressHUD dismiss];
}

- (void)reRefresh
{
    [CPNotificationCenter postNotificationName:CPReRefreshNotification object:nil];
}

@end
