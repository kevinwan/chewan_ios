//  Tools.h
//
//  Created by 牛鹏赛 on 15-7-8.
//  Copyright (c) 2015年 gongpingjia All rights reserved.
//
//

#import "Tools.h"

#import <CommonCrypto/CommonDigest.h>

#define CPUnreadActKey [[NSString alloc]initWithFormat:@"%@unreadAct",[Tools getValueFromKey:@"userId"]]

#define CPUnreadMsgKey [[NSString alloc]initWithFormat:@"%@unreadMsg",[Tools getValueFromKey:@"userId"]]

#define CC_MD5_LENGTH 16

@implementation Tools

+ (BOOL)cpIsLogin
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    if (userId.length == 0 || token.length == 0) {
        return NO;
    }
    return YES;
}

+(BOOL) isEmptyOrNull:(NSString *) str {
    if (!str) {
        // null object
        return true;
    } else {
        NSString *trimedString = [self trimString:str];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        } else {
            // is neither empty nor null
            return false;
        }
    }
}

#pragma mark -
#pragma mark 清除左右空格
+(NSString *) trimString:(NSString *) str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(BOOL) isValidateRegex:(NSString *)text regex:(NSString *)strRegex{
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [phoneTest evaluateWithObject:text];
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+(BOOL)isValidatePwd:(NSString *)pwd{
//    NSString *pwdRegex = @"^[a-zA-Z0-9]{5,14}$";
    NSString * pwdRegex = @"^[a-zA-Z0-9][a-zA-Z0-9_]{5,14}$";
    
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    return [pwdTest evaluateWithObject:pwd];
}

+(BOOL)isValidateIdentityCode : (NSString *)identityCode{
    NSString *identityCodeRegex = @"^\\d{4}$";
    NSPredicate *identityCodeTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", identityCodeRegex];
    return [identityCodeTest evaluateWithObject:identityCode];
}

//身份证号
+ (BOOL) isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSString *regex2 = @"^(\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(UILabel *)CreatLableWithText:(NSString *)text andFont:(float)font
{
    UILabel *lable=[[UILabel alloc]init];
    lable.text=text;
    lable.font=[UIFont systemFontOfSize:font];
    lable.textAlignment=1;
    lable.backgroundColor=[UIColor clearColor];
    return lable;
    
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+(UIButton*)CreateButtonWithTitle:(NSString*)title
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(103, 103, 103, 1.0) forState:UIControlStateHighlighted];
    btn.titleLabel.font = UNI_FONT_SIZE_15;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return btn;
}

+(UITextField*)createTextFiedLeftView:(NSString*)imageName andPlaceholder:(NSString*)placeholder
{
    UITextField* field  = [[UITextField alloc] initWithFrame:CGRectZero];
    field.backgroundColor = [UIColor colorWithRed:237/255.0 green:218/255.0 blue:183/255.0 alpha:1.0];
    field.font = [UIFont systemFontOfSize:12];
    field.borderStyle = UITextBorderStyleNone;
    field.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    field.leftView = img;
    field.placeholder = placeholder;
    
    return field;
}

//是否登录
+ (BOOL) hasLogin{
//    NSString * userid = getValueFromKeyForUserId(LANGBO_USERDEFAULT_USERID);
    
    NSString * userid = [self getValueFromKeyForUserId:WANCHE_USERDEFAULT_USERID];
    
//    NSString * userid = @"";
    
    if (![self isEmptyOrNull:userid] && [userid length] >0){
        return YES;
    }
    else{
        return NO;
    }
}

+(void)AlertString:(NSString*)str{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

//退出登录
+ (void) loginOut{
    
//    [self setValueForKeyForUserId:@"" key:UNI_USERDEFAULT_USERID];
//    [self setValueForKey:@"" key:UNI_USERDEFAULT_USERNAME];
//    [self setValueForKey:@"" key:UNI_USERDEFAULT_USERTOKEN];
//    [self setValueForKey:@"" key:UNI_USERDEFAULT_USERICON];
//    [self setValueForKey:@"" key:UNI_USERDEFAULT_COMPANYID];
//    [self setValueForKey:@"" key:UNI_USERDEFAULT_COMPANYNAME];
    
}

+(UIColor *) getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}
//
//id getValueFromKeyForUserId(NSString *keyInDefaults){
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id results = [defaults valueForKey:keyInDefaults];
//    return results;
//}
//id getValueFromKey(NSString *keyInDefaults){
//    NSString *strKey = [keyInDefaults stringByAppendingString:UNI_USER_ID];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id results = [defaults valueForKey:strKey];
//    return results;
//}

+(id) getValueFromKeyForUserId:(NSString *)keyInDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id results = [defaults valueForKey:keyInDefaults];
    if([self isEmptyOrNull:results]){
        results = @"";
    }
    return results;
}
+(id) getValueFromKey:(NSString *)keyInDefaults{
    //NSString *strKey = [keyInDefaults stringByAppendingString:UNI_USER_ID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id results = [defaults valueForKey:keyInDefaults];
    return results;
}

+ (void) setValueForKeyForUserId:(id) value key:(NSString *) key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}
+ (void) setValueForKey:(id) value key:(NSString *) key{
    //NSString *strKey = [key stringByAppendingString:UNI_USER_ID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}

void setValueForKey(id value,NSString *key){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}

id getValueFromKey(NSString *keyInDefaults){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id results = [defaults valueForKey:keyInDefaults];
    return results;
}

//格式化日期
+ (NSString *)formatDate:(NSTimeInterval)timeInterval
{
    //调整8小时的时差
//    timeInterval -= (8*60*60);
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateformatter stringFromDate:startDate];
}

+ (NSString *)formatDateWithFormat:(NSString *)format timeInteval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    return [dateformatter stringFromDate:date];
}
#pragma mark 谈出框过度动画
+(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur
{
    return;
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}
#pragma mark 视图消失的效果
+(void)exChangeHiden:(UIView *)changeOutView dur:(CFTimeInterval)dur
{
    return;
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]];
    
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
    
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

- (NSString *)shortUrl:(NSString *)url

{
    
    NSArray *chars = [[NSArray alloc] initWithObjects:@"a" , @"b" , @"c" , @"d" , @"e" , @"f" , @"g" , @"h" ,
                      
                      @"i" , @"j" , @"k" , @"l" , @"m" , @"n" , @"o" , @"p" , @"q" , @"r" , @"s" , @"t" ,
                      
                      @"u" , @"v" , @"w" , @"x" , @"y" , @"z" , @"0" , @"1" , @"2" , @"3" , @"4" , @"5" ,
                      
                      @"6" , @"7" , @"8" , @"9" , @"A" , @"B" , @"C" , @"D" , @"E" , @"F" , @"G" , @"H" ,
                      
                      @"I" , @"J" , @"K" , @"L" , @"M" , @"N" , @"O" , @"P" , @"Q" , @"R" , @"S" , @"T" ,
                      
                      @"U" , @"V" , @"W" , @"X" , @"Y" , @"Z", nil];
    
    NSLog(@"chars = %d", [chars count]);
    
    NSString *key = @"xxxxxx";
    
    
    const char *original_str = [[key stringByAppendingFormat:@"%@",url] UTF8String];
    unsigned char result[CC_MD5_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    NSString *hex = [NSString stringWithFormat:@"%@",[hash lowercaseString]];
    
    NSLog(@"hex = %@", hex);
    
    NSMutableArray *resUrl = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i=0; i<4; i++) {
        
        // 把加密字符按照 8 位一组 16 进制与 0x3FFFFFFF 进行位与运算
        
        NSString *sTempSubString = [hex substringWithRange:NSMakeRange(i*8, 8)];
        
        
        
        // 这里需要使用 long 型来转换，因为 Inteper只能处理 31 位 , 首位为符号位 , 如果不用 long ，则会越界
        
        long longOfTemp;
        
        sscanf([sTempSubString cStringUsingEncoding:NSASCIIStringEncoding], "%lx", &longOfTemp);
        
        long lHexLong = 0x3FFFFFFF & longOfTemp;
        
        NSString *outChars = @"";
        
        for (int j=0; j<6; j++) {
            
            // 把得到的值与 0x0000003D 进行位与运算，取得字符数组 chars 索引
            
            long index = 0x0000003D & lHexLong;
            
            // 把取得的字符相加
            
            outChars = [outChars stringByAppendingFormat:@"%@",[chars objectAtIndex:(int)index]];
            
            // 每次循环按位右移 5 位
            
            lHexLong = lHexLong >> 5;
            
        }
        
        // 把字符串存入对应索引的输出数组
        
        [resUrl insertObject:outChars atIndex:i];
        
    }
    
    return [resUrl objectAtIndex:0];//这里可以返回任意一个元素作为短链接（0，1，2，3）
    
}

+(NSArray *)applyEmtitiesWithloginUser:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *defalutData = [defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    return ary;
}

+ (void)setUnreadAct:(NSString *)count
{
    [CPUserDefaults setValue:count forKey:CPUnreadActKey];
    [CPUserDefaults synchronize];
}

+ (void)setUnreadMsg:(NSString *)count
{
    [CPUserDefaults setValue:count forKey:CPUnreadMsgKey];
    [CPUserDefaults synchronize];
}

+ (NSUInteger)getUnreadAct
{
    return [[CPUserDefaults valueForKey:CPUnreadActKey] intValue];
}

+ (NSUInteger)getUnreadMsg
{
    return [[CPUserDefaults valueForKey:CPUnreadMsgKey] intValue];
}

+ (NSUInteger)getZyUnreadMsgCount
{
    return [self getUnreadMsg] + [self getUnreadAct];
}

@end
