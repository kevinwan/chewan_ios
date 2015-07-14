//
//  CPIconButton.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPIconButton.h"

@implementation CPIconButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.clipsToBounds = YES;
}

@end
