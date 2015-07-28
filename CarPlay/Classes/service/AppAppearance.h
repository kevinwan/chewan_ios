//
//  AppAppearance.h
//  dealer
//
//  Created by GongpingjiaNanjing on 15/6/25.
//  Copyright (c) 2015年 GongpingjiaNanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 配置一些整个应用都适用的appearance，以及一些通用颜色字体常量
@interface AppAppearance : NSObject

+ (UIColor *)redColor;

+ (UIColor *)greenColor;

+ (UIColor *)titleColor;

+ (UIColor *)textDarkColor;

+ (UIColor *)textMediumColor;

+ (UIColor *)lineColor;

+ (UIColor *)backgroundColor;

+ (UIColor *)btnBackgroundColor;

+ (UIColor *)labelPromptColor;

#pragma mark - font

+ (UIFont *)titleFont;

+ (UIFont *)textLargeFont;

+ (UIFont *)textMediumFont;


@end
