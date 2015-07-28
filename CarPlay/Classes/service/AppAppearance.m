//
//  AppAppearance.m
//  dealer
//
//  Created by GongpingjiaNanjing on 15/6/25.
//  Copyright (c) 2015年 GongpingjiaNanjing. All rights reserved.
//

#import "AppAppearance.h"
#import "SMFoundation.h"

#define CreateLazyColor(colorValue) \
static UIColor * color = nil;\
if (color == nil) {\
color = [UIColor colorWithHexString:colorValue];\
}\
return color


#define CreateLazyFont(fontSize) \
static UIFont * font = nil;\
if (font == nil) {\
font = [UIFont systemFontOfSize:fontSize];\
}\
return font

@implementation AppAppearance

#pragma mark - life cycle




#pragma mark - color

+ (UIColor *)redColor
{
    CreateLazyColor(@"fc6e51");
}


+ (UIColor *)greenColor
{
    CreateLazyColor(@"48d1d5");
}

+ (UIColor *)titleColor
{
    CreateLazyColor(@"ffffff");
}

+ (UIColor *)textDarkColor
{
    CreateLazyColor(@"434a53");
}


+ (UIColor *)textMediumColor
{
    CreateLazyColor(@"aab2bd");
}


+ (UIColor *)lineColor
{
    CreateLazyColor(@"e5e5e5");
}

+ (UIColor *)btnBackgroundColor
{
    CreateLazyColor(@"f1f1f1");
}

+ (UIColor *)backgroundColor
{
    CreateLazyColor(@"f7f7f7");
}
+ (UIColor *)labelPromptColor
{

    CreateLazyColor(@"656c78");
}

#pragma mark - font

+ (UIFont *)titleFont
{
    CreateLazyFont(20.0f);
}


+ (UIFont *)textLargeFont
{
    CreateLazyFont(16.0f);
}


+ (UIFont *)textMediumFont
{
    CreateLazyFont(14.0f);
}


@end
