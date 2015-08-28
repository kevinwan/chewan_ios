//
//  CPTipView.m
//  CarPlay
//
//  Created by chewan on 15/8/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTipView.h"

@interface CPTipView ()
@property (nonatomic, copy) completion completion;
@property (nonatomic, copy) cancle cancle;
@property  (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CPTipView

+ (void)showWithConfirm:(completion)completion cancle:(cancle)cancle
{
    CPTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"CPTipView" owner:nil options:nil]lastObject];
    view.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    view.bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    view.frame = [UIScreen mainScreen].bounds;
    view.completion = completion;
    view.cancle = cancle;
    [[UIApplication sharedApplication].windows.lastObject addSubview:view];
    
}

- (IBAction)confirm:(id)sender
{
    
    if (self.completion) {
        self.completion();
    }
    [self removeFromSuperview];
    
}


- (IBAction)cancle:(id)sender
{
    if (self.cancle) {
        self.cancle();
    }
    [self removeFromSuperview];
}
@end
