//
//  CPSegment.m
//  CarPlay
//
//  Created by chewan on 15/8/5.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSegment.h"

@implementation CPSegment

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
    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[Tools getColor:@"aab2bd"] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = [Tools getColor:@"fc6e51"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
