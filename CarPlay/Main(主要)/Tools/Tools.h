//
//  Tools.h
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

@property (nonatomic, strong) UIColor *redColor;
@property (nonatomic, strong) UIColor *greenColor;
@property (nonatomic, strong) UIColor *blueColor;
@property (nonatomic, strong) UIColor *grayColor;

+ (NSString *)getUserId;

+ (NSString *)getToken;

+ (BOOL)isLogin;

+ (BOOL)isUnLogin;

+ (BOOL)isNoNetWork;

@end
