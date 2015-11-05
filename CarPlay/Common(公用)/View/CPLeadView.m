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
    [self showGuideViewWithImageName:imageName frame:CGRectZero];
}

+ (void)showGuideViewWithImageName:(NSString *)imageName frame:(CGRect)frame
{
    BOOL firstShow = [[NSUserDefaults standardUserDefaults] boolForKey:imageName];
    
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
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [guideView addSubview:imageView];
        if (CGRectIsEmpty(frame)) {
            imageView.center = guideView.centerInSelf;
        }else{
            if (frame.origin.x) {
                imageView.x = frame.origin.x;
            }
            
            if (frame.origin.y) {
                imageView.y = frame.origin.y;
            }
            
            if (frame.size.width) {
                imageView.width = frame.size.width;
            }
            
            if (frame.size.height) {
                imageView.height = frame.size.height;
            }
        }
        [window addSubview:guideView];
    }
    
}

@end
