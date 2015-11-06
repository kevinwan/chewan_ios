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
    NSString *imageKey = [imageName stringByAppendingString:@"CPGuideViewKey"];
    BOOL firstShow = [ZYUserDefaults boolForKey:imageKey];
    
    if (firstShow == NO) {
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        CPGuideView *guideView = [[CPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (iPhone4) {
            imageName = [imageName stringByAppendingString:@"_4"];
        }else if (iPhone5){
            imageName = [imageName stringByAppendingString:@"_5"];
        }else if (iPhone6){
            imageName = [imageName stringByAppendingString:@"_6"];
        }else if (iPhone6P){
            imageName = [imageName stringByAppendingString:@"_6p"];
        }
        guideView.image = [UIImage imageNamed:imageName];
        
        [ZYUserDefaults setBool:YES forKey:imageKey];
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
