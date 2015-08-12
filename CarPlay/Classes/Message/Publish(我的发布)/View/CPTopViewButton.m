//
//  CPTopViewButton.m
//  CarPlay
//
//  Created by chewan on 15/7/16.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTopViewButton.h"
#import "NSString+Extension.h"

@implementation CPTopViewButton

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
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self setTitleColor:[Tools getColor:@"656c78"] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
}

/**
 *  自定义imageView和titleLable的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, 0, 14, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 24;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self setTitle:text forState:UIControlStateNormal];
}

@end
