//
//  CPNavigationBar.m
//  CarPlay
//
//  Created by chewan on 11/4/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPNavigationBar.h"

@implementation CPNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 对导航栏左右按钮的位置进行重新调节
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        
        if ([subview isKindOfClass:[UIButton class]] && subview.frame.origin.x < self.frame.size.width * 0.5) {
            subview.x = 10;
        }
//        else if ([subview isKindOfClass:[UIButton class]] && subview.frame.origin.x > self.frame.size.width * 0.5){
//            subview.x = self.width - subview.width - 10;
//        }
    }
}


@end
