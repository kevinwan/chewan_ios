//
//  CPSegmentControl.m
//  CarPlay
//
//  Created by chewan on 15/8/5.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSegmentControl.h"

@implementation CPSegmentControl

- (void)awakeFromNib
{
    for (UIView *view in self.subviews) {
        for (UIView *subView in view.subviews) {
            subView.backgroundColor = [UIColor redColor];
            if ([subView isKindOfClass:[UIImageView class]]){
                subView.hidden = YES;
            }
        }
    }
}
@end
