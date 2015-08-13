//
//  CPChatButton.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPChatButton.h"

@implementation CPChatButton

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
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.clipsToBounds = YES;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"fc6e51"];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width += 10;
}

- (void)showApplying
{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"f1f1f1"];
    [self setTitle:@"申请中" forState:UIControlStateNormal];
}

@end
