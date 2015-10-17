//
//  ZYProgressView.m
//  CarPlay
//
//  Created by chewan on 10/14/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYProgressView.h"

@implementation ZYProgressView
static BOOL _isShow;

+ (void)showMessage:(NSString *)message
{
    [self showMessage:message inView:nil];
}

+ (void)showMessage:(NSString *)message inView:(UIView *)view
{
    // 0. 避免重复显示
    if (_isShow) return;
    
    // 1. 创建背景的标签
    UIView *tipView = [[UIView alloc] init];
    [tipView setCornerRadius:10];
    tipView.clipsToBounds = YES;
    tipView.backgroundColor = ZYColor(0, 0, 0, 0.8);
    tipView.size = CGSizeMake(220, 44);
    tipView.alpha = 0.5;
    if (view == nil){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [view addSubview:tipView];
    _isShow = YES;
    
    // 2. 创建显示文字的label
    UILabel *showLabel = [[UILabel alloc] init];
    [tipView addSubview:showLabel];
    showLabel.text = message;
    showLabel.textColor = [UIColor whiteColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [showLabel sizeToFit];
    
    // 3. 根据屏幕的宽度,对间距和字体进行微调
    
//    if (ZYScreenWidth == 320) {
//        showLabel.font = [UIFont systemFontOfSize:11];
//    }else{
//        showLabel.font = [UIFont systemFontOfSize:13];
//    }
//    
//    if (ZYScreenWidth == 320) {
//        tipView.width = showLabel.width ;
//        tipView.height = showLabel.height + 8;
//    }else{
//        
//        tipView.width = showLabel.width + 30;
//        tipView.height = showLabel.height + 18;
//    }
    tipView.centerX = view.middleX;
    tipView.y = ZYScreenHeight - tipView.height - 100;
    
    showLabel.centerX = tipView.middleX;
    showLabel.centerY = tipView.middleY;
    
    // 4. 制作动画显示和消失视图
    [UIView animateWithDuration:0.25 animations:^{
        tipView.alpha = 1;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                tipView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [tipView removeFromSuperview];
                _isShow = NO;
            }];
        });
    }];
}

+ (void)showGoLoginWithTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"你还未登录,登录后就可以%@",title] delegate:nil cancelButtonTitle:@"再想想" otherButtonTitles:@"去登录", nil];
    [alertView.rac_buttonClickedSignal subscribeNext:^(id x) {
        if ([x integerValue] != 0) {
            [ZYNotificationCenter postNotificationName:NOTIFICATION_GOLOGIN object:nil];
        }
    }];
    [alertView show];
}

@end
