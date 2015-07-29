//
//  UIViewController+ZY.h
//  CarPlay
//
//  Created by chewan on 15/7/29.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZY)

#pragma mark - 处理提示信息
/**
 *  转圈圈,不会自动消失,需要手动dismiss
 */
- (void)showLoading;

/**
 *  转圈圈,不会自动消失,需要手动dismiss
 */
- (void)showLoadingWithInfo:(NSString *)info;

/**
 *  显示提示信息,自动消失
 *
 *  @param info 需要提示的信息
 */
- (void)showInfo:(NSString *)info;

/**
 *  显示错误信息有个叉号
 *
 *  @param error 错误信息
 */
- (void)showError:(NSString *)error;

/**
 *  提示成功信息,有对号
 *
 *  @param success 提示信息
 */
- (void)showSuccess:(NSString *)success;

/**
 *  清楚正在显示的视图
 */
- (void)disMiss;

- (void)showNoData;

@end
