//
//  CPActivityApplyButton.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyButton.h"
#import "Tools.h"

@implementation CPActivityApplyButton

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
    self.layer.cornerRadius = 12;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.clipsToBounds = YES;
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [Tools getColor:@"f1f1f1"];
        [self setTitle:@"拒绝" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [Tools getColor:@"fc6e51"];
        [self setTitle:@"同意" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [super setSelected:selected];
}

@end
