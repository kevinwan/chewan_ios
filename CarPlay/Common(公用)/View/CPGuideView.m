//
//  CPGuideView.m
//  CarPlay
//
//  Created by chewan on 15/8/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPGuideView.h"

@interface CPGuideView ()

@end

@implementation CPGuideView

+ (void)showGuideViewWithImageName:(NSString *)imageName
{
    BOOL firstShow = [CPUserDefaults boolForKey:[imageName stringByAppendingString:@"CPGuideViewKey"]];
    
    if (firstShow == NO) {
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        CPGuideView *guideView = [[CPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        guideView.image = [UIImage imageNamed:imageName];
        
        [CPUserDefaults setBool:YES forKey:imageName];
        [CPUserDefaults synchronize];
        [window addSubview:guideView];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)hide:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.25 animations:^{
        tap.view.alpha = 0;
    }completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

@end
