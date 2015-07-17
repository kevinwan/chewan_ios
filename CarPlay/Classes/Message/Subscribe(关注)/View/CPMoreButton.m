//
//  CPMoreButton.m
//  CarPlay
//
//  Created by chewan on 15/7/15.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMoreButton.h"

@implementation CPMoreButton

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
    [self setBackgroundColor:[Tools getColor:@"ccd1d9"]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = self.width * 0.5;
    self.clipsToBounds = YES;
}

@end
