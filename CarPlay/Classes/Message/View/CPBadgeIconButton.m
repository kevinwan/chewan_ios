//
//  CPBadgeIconButton.m
//  CarPlay
//
//  Created by chewan on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPBadgeIconButton.h"

@interface CPBadgeIconButton ()
@property (nonatomic, strong) UILabel *redUnreadLabelPoint;
@end

@implementation CPBadgeIconButton

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
    _redUnreadLabelPoint = [[UILabel alloc] init];
    _redUnreadLabelPoint.backgroundColor = [Tools getColor:@"fc6e51"];
    _redUnreadLabelPoint.layer.cornerRadius = 4.5;
    _redUnreadLabelPoint.clipsToBounds = YES;
    _redUnreadLabelPoint.hidden=YES;
    [self addSubview:_redUnreadLabelPoint];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
