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
    [self sizeToFit];
}

- (void)setOnImage:(UIImage *)onImage
{
    [self setBackgroundImage:onImage forState:UIControlStateSelected];
}

- (void)setOffImage:(UIImage *)offImage
{
    [self setBackgroundImage:offImage forState:UIControlStateNormal];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    self.selected = on;
}

@end
