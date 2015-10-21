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
@property (nonatomic, strong) CABasicAnimation *wheelViewAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *lightViewAnimation;
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
    self.size = CGSizeMake(40, 21);
    self.backgroundColor = [UIColor clearColor];
    self.wheelView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"车轮"]];
    [self addSubview:self.wheelView];
    
    self.roadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"路"]];
    [self addSubview:self.roadView];
    
    self.lightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"光"]];
    [self addSubview:self.lightView];
}

- (void)startAnimation
{
    [self.wheelView addAnimation:self.wheelViewAnimation forKey:@"wheelView"];
    [self.lightView addAnimation:self.lightViewAnimation forKey:@"lightView"];
}

- (void)stopAnimation
{
    [self.wheelView.layer removeAnimationForKey:@"wheelView"];
    [self.lightView.layer removeAnimationForKey:@"lightView"];
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
        anima.duration=0.4;
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
        animation.values = @[@40,@36, @32, @28,@24,@20,@16,@12,@8,@4, @0];
        animation.duration = 1;
        animation.repeatCount = MAXFLOAT;
        _lightViewAnimation = animation;
    }
    return _lightViewAnimation;
}

@end
