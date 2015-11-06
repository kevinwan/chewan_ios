//
//  ZYTableViewCell.m
//  CarPlay
//
//  Created by chewan on 15/8/7.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYTableViewCell.h"

@implementation ZYTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    line.backgroundColor = [Tools getColor:@"efefef"];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

@end
