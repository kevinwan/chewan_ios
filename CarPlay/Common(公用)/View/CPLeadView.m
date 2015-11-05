//
//  CPGuideView.m
//  CarPlay
//
//  Created by chewan on 15/8/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPLeadView.h"

@interface CPLeadView ()

@end

@implementation CPLeadView

+ (void)showGuideViewWithImageName:(NSString *)imageName
{
    [self showGuideViewWithImageName:imageName centerX:0 y:0];
}

+ (void)showGuideViewWithImageName:(NSString *)imageName centerX:(CGFloat)centerX y:(CGFloat)y
{
    BOOL firstShow = [[NSUserDefaults standardUserDefaults] boolForKey:[imageName stringByAppendingString:@"CPLeadViewKey"]];
    
    if (firstShow == NO) {
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        UIButton *guideView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        guideView.backgroundColor = ZYColor(0, 0, 0, 0.5);
        [[guideView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [UIView animateWithDuration:0.25 animations:^{
                guideView.alpha = 0;
            }completion:^(BOOL finished) {
                [guideView removeFromSuperview];
            }];
        }];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [guideView addSubview:imageView];
        imageView.center = guideView.centerInSelf;
        
        if (centerX) {
            imageView.centerX = centerX;
        }
        if (y) {
            imageView.y = y;
        }
        
        [window addSubview:guideView];
    }
    
}

@end
