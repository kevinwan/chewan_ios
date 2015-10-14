//
//  ZYRefreshView.m
//  CarPlay
//
//  Created by chewan on 10/14/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYRefreshView.h"

@interface ZYRefreshView ()
@property (nonatomic, strong) UIImageView *wheelView;
@property (nonatomic, strong) UIImageView *roadView;
@property (nonatomic, strong) UIImageView *lightView;
@end

@implementation ZYRefreshView

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
    self.backgroundColor = [UIColor clearColor];
    self.wheelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"车轮"]];
    [self addSubview:self.wheelView];
    CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:@"transform"];
    anima.duration=0.4;
    anima.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1)];
    anima.removedOnCompletion=NO;
    anima.fillMode=kCAFillModeForwards;
    anima.repeatCount = MAXFLOAT;
    [self.wheelView addAnimation:anima];
    
    self.roadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"路"]];
    [self addSubview:self.roadView];
    
    self.lightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"光"]];
    [self addSubview:self.lightView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.width = 40;
    self.height = 21;
    self.wheelView.y = 4;
    self.wheelView.centerX = self.centerX;
    
    self.roadView.y = self.wheelView.bottom + 1;
    self.roadView.centerX = self.centerX;
    
    self.lightView.centerY = self.roadView.centerY;
    self.lightView.x = self.roadView.left;
}

@end
