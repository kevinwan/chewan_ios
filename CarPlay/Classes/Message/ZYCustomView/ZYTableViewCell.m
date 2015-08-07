//
//  ZYTableViewCell.m
//  CarPlay
//
//  Created by chewan on 15/8/7.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYTableViewCell.h"

@interface ZYTableViewCell()
@property (nonatomic, weak) UIView *line;
@end

@implementation ZYTableViewCell

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
    UIView *line = [[UIView alloc] init];
    line.height = 0.5;
    line.backgroundColor = [Tools getColor:@"e6e9ed"];
    [self addSubview:line];
    self.line = line;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.line.x = 0;
    self.line.y = self.height - 0.5;
    self.line.width = self.width;
}

@end
