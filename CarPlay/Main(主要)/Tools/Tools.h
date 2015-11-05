//
//  Tools.h
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZYZipImageCompletion)(NSData *data);

#define RedColor   [Tools getColor:@"fe5969"]
#define GreenColor [Tools getColor:@"74ced6"]
#define GrayColor  [Tools getColor:@"cccccc"]
#define ZYLongitude [Tools getLongitude]
#define ZYLatitude [Tools getLatitude]

@interface Tools : NSObject

+ (void)zipImage:(UIImage *)image completion:(ZYZipImageCompletion)completion;

/**
 *  清楚Af图片缓存
 *
 *  @param url key
 */
- (void)clearAFImageCacheWithUrl:(NSString *)url;

/**
 *  清楚af的网络缓存
 */
- (void)clearAFNetWorkingUrlCache;

/**
 *  添加动词
 */
+ (NSString *)activityTypeWithString:(NSString *)type;
/**
 *  去除活动动词
 */
+ (NSString *)activityNoTypeWithString:(NSString *)type;

+ (NSString *)getUserId;

+ (NSString *)getToken;

+ (BOOL)isLogin;

+ (BOOL)isUnLogin;

+ (BOOL)isNoNetWork;

+ (UIColor *)getColor:(NSString *)hex;

+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL) isValidatePassword:(NSString *)password;

+(double) getLatitude;

+(double)getLongitude;

+ (NSString *)md5EncryptWithString:(NSString*)string;
@end
