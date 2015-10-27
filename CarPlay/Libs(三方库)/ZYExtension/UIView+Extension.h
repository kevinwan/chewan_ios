//
//  UIView+Extension.h
//  ZYSu
//
//  Created by Mac on 10/7/14.
//  Copyright (c) 2014 xiaoma. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 动画效果

// 旋转rotation.x
#define ZYAnimationRotationXKey     @"transform.rotation.x"
#define ZYAnimationRotationYKey     @"transform.rotation.y"
#define ZYAnimationRotationZKey     @"transform.rotation.z"
#define ZYAnimationRotationKey      @"transform.rotation"

// 缩放
#define ZYAnimationScaleXKey        @"transform.scale.x"
#define ZYAnimationScaleYKey        @"transform.scale.y"
#define ZYAnimationScaleZKey        @"transform.scale.z"
#define ZYAnimationScaleKey         @"transform.scale"

// 平移
#define ZYAnimationTranslationXKey  @"transform.translation.x"
#define ZYAnimationTranslationYKey  @"transform.translation.y"
#define ZYAnimationTranslationZKey  @"transform.translation.z"
#define ZYAnimationTranslationKey   @"transform.translation"

// 转场动画
UIKIT_EXTERN NSString * const ZYTransitionTypeCube;    // 立方体翻转效果
UIKIT_EXTERN NSString * const ZYTransitionTypeOglFlip; // 翻转效果
UIKIT_EXTERN NSString * const ZYTransitionTypeSuckEffect; //收缩效果
UIKIT_EXTERN NSString * const ZYTransitionTypeRippleEffect; // 水滴效果
UIKIT_EXTERN NSString * const ZYTransitionTypePageCurl;   //向上翻页效果
UIKIT_EXTERN NSString * const ZYTransitionTypePageUnCurl; // 向下翻页效果

@interface UIView (Extension)

#pragma - mark  用来快速访问和设置View的常用属性

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic) CGPoint centerInSelf;
- (NSString *)frameStr;

// 设置底部的前提是有高度
- (CGFloat)bottom; // 底部
- (CGFloat)left;   // 最左
- (CGFloat)right;  // 最右
- (CGFloat)top;    // 顶部
- (CGFloat)middleX; // 中点x
- (CGFloat)middleY; // 中点y

#pragma mark - 截图方法
- (UIImage *)captureImage;

// 添加核心动画的简化方法
- (void)addAnimation:(CAAnimation *)animation;

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key;

// 设置圆角
- (void)setCornerRadius:(CGFloat)radius;

/**
 *  获取touches的point
 */
- (CGPoint)pointWithTouches:(NSSet *)touches;

- (UIViewController *)viewController;

@end