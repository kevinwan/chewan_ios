//
//  CPOrganizerButton.m
//  CarPlay
//
//  Created by chewan on 15/8/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  自定义按钮显示头像和label

#import "CPOrganizerButton.h"
#import "UIButton+WebCache.h"

@implementation CPOrganizerButton

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
    self.userInteractionEnabled = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self setTitleColor:[Tools getColor:@"656C78"] forState:UIControlStateNormal];
    self.contentMode = UIViewContentModeRight;
    self.imageView.layer.cornerRadius = 12.5;
    self.imageView.clipsToBounds = YES;
}

/**
 *  自定义imageView和titleLable的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat witdh = [self.name sizeWithFont:[UIFont systemFontOfSize:16]].width + 2;
    CGFloat imageX = contentRect.size.width - witdh - 35;
    return CGRectMake(imageX, 0, 25, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat witdh = [self.name sizeWithFont:[UIFont systemFontOfSize:16]].width + 2;
    CGFloat titleX = contentRect.size.width - witdh;
    CGFloat titleY = 0;
    CGFloat titleW = witdh;
    CGFloat titleH = 25;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    [self setTitle:name forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setIcon:(NSString *)icon
{
    _icon = [icon copy];
    [self sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self setNeedsLayout];
}

@end
