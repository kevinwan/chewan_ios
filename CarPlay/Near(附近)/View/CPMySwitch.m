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
    CATransition *t = [CATransition new];
    t.type = ZYTransitionTypeCube;
    [self.imageView addAnimation:t forKey:nil];
    [self sizeToFit];
    self.clipsToBounds = YES;
}

- (void)setOnImage:(UIImage *)onImage
{
    [self setImage:onImage forState:UIControlStateSelected];
}

- (void)setOffImage:(UIImage *)offImage
{
    [self setImage:offImage forState:UIControlStateNormal];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    self.selected = on;
}

@end
