//
//  Tools.h
//
//  Created by 牛鹏赛 on 15-7-8.
//  Copyright (c) 2015年 gongpingjia All rights reserved.
//

#import <Foundation/Foundation.h>


//公共的静态方法，都写在这里，方便调用

@interface Tools : NSObject
+(NSString *)shortUrl:(NSString *)url;
+(BOOL) isEmptyOrNull:(NSString *) str;
+(NSString *) trimString:(NSString *) str;
+(BOOL) isValidateRegex:(NSString *)mobile regex:(NSString *)strRegex;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidatePwd:(NSString *)pwd;
+ (BOOL) isValidateIdentityCard: (NSString *)identityCard;
+(UIButton*)CreateButtonWithTitle:(NSString*)title;
+(UITextField*)createTextFiedLeftView:(NSString*)imageName andPlaceholder:(NSString*)placeholder;

+(UILabel*)CreatLableWithText:(NSString *)text andFont:(float)font;
+ (NSString *)formatDate:(NSTimeInterval)timeInterval;

+ (BOOL) hasLogin;
+ (void) loginOut;
+(UIColor *) getColor:(NSString *)hexColor;


+(id) getValueFromKeyForUserId:(NSString *)keyInDefaults;
+(id) getValueFromKey:(NSString *)keyInDefaults;
+(void)AlertString:(NSString*)str;
+ (void) setValueForKeyForUserId:(id) value key:(NSString *) key;
+ (void) setValueForKey:(id) value key:(NSString *) key;
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

void setValueForKey(id value,NSString *key);

id getValueFromKey(NSString *keyInDefaults);

+ (NSString *)formatDateWithFormat:(NSString *)format timeInteval:(NSTimeInterval)timeInterval;
/**
 *  视图出现的动画
 *
 *  @param changeOutView view
 *  @param dur           动画时间
 */
+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur;

/**
 *  视图消失的动画
 *
 *  @param changeOutView view
 *  @param dur           动画时间
 */
+(void)exChangeHiden:(UIView *)changeOutView dur:(CFTimeInterval)dur;

+ (NSString *)md5EncryptWithString:(NSString*)string;
@end
