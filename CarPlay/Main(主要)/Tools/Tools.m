//
//  Tools.m
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString *)getUserId
{
    return [ZYUserDefaults stringForKey:UserId];
}

+ (NSString *)getToken
{
    return [ZYUserDefaults stringForKey:Token];
}

+ (BOOL)isLogin
{
    return [self getUserId].length && [self getToken].length;
}

+ (BOOL)isUnLogin
{
    return ![self isLogin];
}

+ (BOOL)isNoNetWork
{
    return [XMNetStatuesTool isNoNetWork];
}

+ (UIColor *)getColor:(NSString *)hex
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hex substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hex substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hex substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
@end
