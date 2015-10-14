//
//  UIViewController+ZY.m
//  CarPlay
//
//  Created by chewan on 15/7/29.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "UIViewController+ZY.h"

@implementation UIViewController (ZY)

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
    [ZYNotificationCenter postNotificationName:CPReRefreshNotification object:nil];
}

@end
