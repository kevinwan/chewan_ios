//
//  Tools.m
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#define CC_MD5_LENGTH 16

@implementation Tools

+ (void)zipImage:(UIImage *)image completion:(ZYZipImageCompletion)completion
{
    CGSize size = CGSizeMake(300, 250);
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(scaledImage, 1.0);
    if (completion) {
        completion(data);
    }
}

- (void)clearAFImageCacheWithUrl:(NSString *)url
{
    id<AFImageCache> imageCache = [UIImageView sharedImageCache];
    NSCache *cache = (NSCache *)imageCache;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [cache removeObjectForKey:request];
}

- (void)clearAFNetWorkingUrlCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

static NSDictionary *activityTypes;
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activityTypes = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CPActivityType" ofType:@"plist"]];
    });
}

+ (NSString *)activityTypeWithString:(NSString *)type
{
    __block NSString *result = [type copy];
    [activityTypes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:type]) {
            result = obj;
        }
    }];
    return result;
}

+ (NSString *)activityNoTypeWithString:(NSString *)type
{
    __block NSString *result = [type copy];
    [activityTypes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:type]) {
            result = key;
        }
    }];
    return result;
}


+ (NSString *)getUserId
{
    return [ZYUserDefaults stringForKey:UserId];
}

+ (NSString *)getToken
{
    return [ZYUserDefaults stringForKey:Token];
}

+(double) getLatitude
{
    return [ZYUserDefaults doubleForKey:Latitude];
}

+(double)getLongitude
{
    return [ZYUserDefaults doubleForKey:Longitude];
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

+(BOOL) isValidatePassword:(NSString *)password{
    // 特殊字符包含`、-、=、\、[、]、;、'、,、.、/、~、!、@、#、$、%、^、&、*、(、)、_、+、|、?、>、<、"、:、{、}
    // 必须包含数字和字母，可以包含上述特殊字符。
    // 依次为（如果包含特殊字符）
    // 数字 字母 特殊
    // 字母 数字 特殊
    // 数字 特殊 字母
    // 字母 特殊 数字
    // 特殊 数字 字母
    // 特殊 字母 数字
    NSString *passWordRegex = @"(\\d+[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|([a-zA-Z]+\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|(\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+)|([a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+[a-zA-Z]+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+\\d+)";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    BOOL validate=[passWordPredicate evaluateWithObject:password];
    if (password.length<6 || password.length>15) {
        validate = FALSE;
    }
    return validate;
}

+ (NSString *)md5EncryptWithString:(NSString*)string
{
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end
