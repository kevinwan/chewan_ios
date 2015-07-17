//
//  CPIconButton.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPIconButton.h"

@implementation CPIconButton

/**
 *  拦截setframe方法 可以获得button最准确的width
 *
 *  @param frame 
 */
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width * 0.5;
    self.clipsToBounds = YES;
}

@end
