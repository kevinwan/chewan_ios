//
//  CPNearParams.h
//  CarPlay
//
//  Created by chewan on 10/13/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNearParams : NSObject
//userId	false	String	访问用户的userId
@property (nonatomic, copy) NSString *userId;
//token	false	String	访问者的 token
@property (nonatomic, copy) NSString *token;
//type	false	String	twsdsewerewesf
@property (nonatomic, copy) NSString *type;
//pay	false	String	付费类型
@property (nonatomic, copy) NSString *pay;
//province	false	String	省份
@property (nonatomic, copy) NSString *province;
//city	false	String	城市
@property (nonatomic, copy) NSString *city;
//district	false	String	区域
@property (nonatomic, copy) NSString *district;
//street	false	String	街道
@property (nonatomic, copy) NSString *street;
//ignore	false	Integer	忽略数量,不传默认0
@property (nonatomic, assign) NSUInteger ignore;
//limit	false	Integer	限制数量，不传默认10
@property (nonatomic, assign) NSUInteger limit;
//longitude	true	String	经度
@property (nonatomic, assign) double longitude;
//latitude	true	String	纬度
@property (nonatomic, assign) double latitude;
//maxDistance	true	String	最大距离
//@property (nonatomic, assign) NSUInteger maxDistance;
@property (nonatomic, assign) BOOL transfer;
@property (nonatomic, copy) NSString *gender;
@end
