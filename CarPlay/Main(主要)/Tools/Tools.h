//
//  Tools.h
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RedColor   [Tools getColor:@"fe5969"]
#define GreenColor [Tools getColor:@"74ced6"]
#define GrayColor  [Tools getColor:@"cccccc"]

@interface Tools : NSObject

+ (NSString *)getUserId;

+ (NSString *)getToken;

+ (BOOL)isLogin;

+ (BOOL)isUnLogin;

+ (BOOL)isNoNetWork;

+ (UIColor *)getColor:(NSString *)hex;

+(BOOL) isValidateMobile:(NSString *)mobile;
@end
