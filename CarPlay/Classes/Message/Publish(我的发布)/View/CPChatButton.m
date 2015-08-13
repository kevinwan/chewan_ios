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
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.layer.cornerRadius = 12.5;
    self.clipsToBounds = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"fc6e51"];
    
    self.width = 70;
    self.height = 25;
}

- (void)showApplying
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"ccd1d9"];
    [self setTitle:@"申请中" forState:UIControlStateNormal];
}

- (void)showManageMember
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"fc6e51"];
    [self setTitle:@"成员管理" forState:UIControlStateNormal];
}

- (void)showHasJoin
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"fc6e51"];
    [self setTitle:@"已加入" forState:UIControlStateNormal];
}
- (void)showToPlay
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [Tools getColor:@"fc6e51"];
    [self setTitle:@"我要去玩" forState:UIControlStateNormal];
}

@end
