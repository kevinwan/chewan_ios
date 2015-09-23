//
//  UIView+Extension.m
//  ZYSu
//
//  Created by Mac on 10/7/14.
//  Copyright (c) 2014 xiaoma. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@interface UIView()
@property (nonatomic, assign) CGFloat tempCenterX;
@property (nonatomic, assign) CGFloat tempCenterY;

@end

NSString * const ZYTransitionTypeCube = @"cube";
NSString * const ZYTransitionTypeOglFlip = @"oglFlip";
NSString * const ZYTransitionTypeSuckEffect = @"suckEffect";
NSString * const ZYTransitionTypeRippleEffect = @"rippleEffect";
NSString * const ZYTransitionTypePageCurl = @"pageCurl";
NSString * const ZYTransitionTypePageUnCurl = @"pageUnCurl";

static const char ZYTempCenterXKey = '\0';
static const char ZYTempCenterYKey = 'a';

@implementation UIView (Extension)

- (void)setTempCenterX:(CGFloat)tempCenterX
{
    objc_setAssociatedObject(self, &ZYTempCenterXKey, @(tempCenterX), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)tempCenterX
{
    return [objc_getAssociatedObject(self, &ZYTempCenterXKey) doubleValue];
}

- (void)setTempCenterY:(CGFloat)tempCenterY
{
    objc_setAssociatedObject(self, &ZYTempCenterYKey, @(tempCenterY), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)tempCenterY
{
    return [objc_getAssociatedObject(self, &ZYTempCenterYKey) doubleValue];
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    if (self.tempCenterX) {
        [self setCenterX:self.tempCenterX];
    }
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    if (self.tempCenterY) {
        [self setCenterY:self.tempCenterY];
    }
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.bounds.size.width;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX
{
    if (self.width) {
        CGPoint center = self.center;
        center.x = centerX;
        self.center = center;
    }else{
        self.tempCenterX = centerX;
    }
}

- (void)setCenterY:(CGFloat)centerY
{
    if (self.height) {
        CGPoint center = self.center;
        center.y = centerY;
        self.center = center;
    }else{
        self.tempCenterY = centerY;
    }
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)middleX
{
    return self.bounds.size.width * 0.5;
}

- (CGFloat)middleY
{
    return self.bounds.size.height * 0.5;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.bounds.size.height;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.bounds.size.width;
}

- (NSString *)frameStr
{
    return NSStringFromCGRect(self.frame);
}

- (UIImage *)captureImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)addAnimation:(CAAnimation *)animation
{
    [self addAnimation:animation forKey:nil];
}

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key
{
    [self.layer addAnimation:animation forKey:key];
}

// 获取触摸点
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}

@end
