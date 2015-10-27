//
//  CPWheelView.m
//  CarPlay
//
//  Created by 公平价 on 15/10/27.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPWheelView.h"

@interface CPWheelView ()
@property (nonatomic, strong) UIImageView *wheelView;
@property (nonatomic, strong) UIImageView *roadView;
@property (nonatomic, strong) UIImageView *lightView;
@property (nonatomic, strong) CABasicAnimation *wheelViewAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *lightViewAnimation;
@end

@implementation CPWheelView
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
    self.size = CGSizeMake(100, 53);
    self.backgroundColor = [UIColor clearColor];
    self.wheelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"轱辘"]];
    [self addSubview:self.wheelView];
    
    self.roadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"轱辘印"]];
    [self addSubview:self.roadView];
    
    self.lightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"轱辘跑点"]];
    [self addSubview:self.lightView];
}

- (void)startAnimation
{
    [self.wheelView addAnimation:self.wheelViewAnimation forKey:@"wheelView1"];
    [self.lightView addAnimation:self.lightViewAnimation forKey:@"lightView1"];
}

- (void)stopAnimation
{
    [self.wheelView.layer removeAnimationForKey:@"wheelView1"];
    [self.lightView.layer removeAnimationForKey:@"lightView1"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.wheelView.y = 4;
    self.wheelView.centerX = self.middleX;
    
    self.roadView.y = self.wheelView.bottom + 1;
    self.roadView.centerX = self.middleX;
    
    self.lightView.centerY = self.roadView.centerY;
    self.lightView.x = self.roadView.left;
}

#pragma mark - lazy
- (CABasicAnimation *)wheelViewAnimation
{
    if (_wheelViewAnimation == nil) {
        CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:@"transform"];
        anima.duration=0.2;
        anima.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1)];
        anima.removedOnCompletion=NO;
        anima.fillMode=kCAFillModeForwards;
        anima.repeatCount = MAXFLOAT;
        _wheelViewAnimation = anima;
    }
    return _wheelViewAnimation;
}

- (CAKeyframeAnimation *)lightViewAnimation
{
    if (_lightViewAnimation == nil) {
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = ZYAnimationTranslationXKey;
        animation.values = @[@100,@90, @80, @70,@60,@50,@40,@30,@20,@10, @0];
        animation.duration = 1;
        animation.removedOnCompletion=NO;
        animation.fillMode=kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
        _lightViewAnimation = animation;
    }
    return _lightViewAnimation;
}
@end
