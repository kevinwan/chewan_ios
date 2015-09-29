//
//  CPMySwitch.m
//  CarPlay
//
//  Created by chewan on 9/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPMySwitch.h"

@implementation CPMySwitch

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
    [self setBackgroundImage:[UIImage imageNamed:@"btn_meikong"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"btn_youkong"] forState:UIControlStateSelected];
    [self setSelected:YES];
    [self sizeToFit];
}

@end
