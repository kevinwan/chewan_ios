//
//  UIView+Dealer.m
//  dealer
//
//  Created by GongpingjiaNanjing on 15/6/29.
//  Copyright (c) 2015年 GongpingjiaNanjing. All rights reserved.
//

#import "UIView+Dealer.h"
#import "MBProgressHUD.h"
#import "AppAppearance.h"
#import "SMCommon.h"

#define kTagWaitView 12580


@implementation UIView (Dealer)


- (void)alert:(NSString *)message
{
    // 防止网路请求fail的时候，errorDescription也是空
    if ([message length] == 0) {
        message = @"数据异常，请检查网络连接或稍后再试";
    }
    [self alert:message type:0];
}


- (void)alert:(NSString *)message type:(NSInteger)type
{
    [self alert:message type:type completion:nil];
}


- (void)alert:(NSString *)message type:(NSInteger)type completion:(dispatch_block_t)completion
{
    [self hideWait];
    // 为什么不hide其他，因为这个除了wait，其他最多1.5秒，没必要再遍历一遍隐藏
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    //    hud.detailsLabelFont = [UIFont systemFontOfSize:12.0f];
    //    hud.detailsLabelText = message;
    
    hud.yOffset = -120.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 60.0f)];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [AppAppearance textLargeFont];
    textLabel.text = message;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    hud.customView = textLabel;
    hud.mode = MBProgressHUDModeCustomView;
    
    [self addSubview:hud];
    [hud show:YES];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [hud hide:YES];
        if (completion) {
            completion();
        }
    });
}


- (void)alertError:(id)result
{
    NSString *errorMsg = nil;
    if ([result isKindOfClass:[NSString class]]) {
        // todosm 如果是网络错误,但是这个错误其实是asi的错误，所以一直到af的时候还要校验一下，可能都不走这里
        if ([result rangeOfString:@"Error Domain"].length > 0) {
            [self alertNetwork];
            return;
        }
        [self alert:errorMsg];
    }
    else if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = result;
        if ([[dic objectForKey:@"errmsg"] isKindOfClass:[NSString class]] && ([[dic objectForKey:@"errmsg"] length] > 0)) {
            errorMsg = [dic objectForKey:@"errmsg"];
        }
        else {
            errorMsg = @"操作失败";
        }
        [self alert:errorMsg];
    }
    else {
        [self alertNetwork];
    }
}


- (void)alertNetwork
{
    [self alert:@"数据异常，请检查网络连接或稍后再试"];
}


- (void)showWait
{
    [self showWaitWithMessage:@""];
}


- (void)showWaitWithMessage:(NSString *)message
{
    [self hideWait];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    //    hud.removeFromSuperViewOnHide = YES;
    hud.tag = kTagWaitView;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
    hud.labelFont = [AppAppearance textLargeFont];
    // todosm 似乎没起作用
    hud.yOffset = -120.0f;
    [self addSubview:hud];
    [self bringSubviewToFront:hud];
    [hud show:YES];
}


- (void)hideWait
{
    [[self viewWithTag:kTagWaitView] removeFromSuperview];
    [MBProgressHUD hideHUDForView:self animated:NO];
}


+ (instancetype)standardSeparateLineWithOrigin:(CGPoint)origin
{
    // 这里默认假设线顶着屏幕尾部
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, kScreenWidth-origin.x, 0.5f)];
    v.backgroundColor = [AppAppearance lineColor];
    return v;
}


+ (instancetype)separateLineViewWithTop:(CGFloat)top left:(CGFloat)left
{
    return [self standardSeparateLineWithOrigin:CGPointMake(left, top)];
}

@end
