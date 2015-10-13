//
//  CPRecommendModel.h
//  CarPlay
//
//  Created by chewan on 10/10/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPRecommendModel : NSObject
//    description = 测试官方活动Description,
@property (nonatomic, copy) NSString *desc;
//    femaleNum = ,
@property (nonatomic, assign) NSUInteger femaleNum;
//    title = 测试官方活动Title,
@property (nonatomic, copy) NSString *title;
//    instruction = 测试官方活动Instruction,
@property (nonatomic, copy) NSString *instruction;

//    destPoint = {
//        longitude = 0,
//        latitude = 0
//    },
@property (nonatomic, strong) NSDictionary *destPoint;
//    maleLimit = 20,
@property (nonatomic, assign) NSUInteger maleLimit;
//    maleNum = ,
@property (nonatomic, assign) NSUInteger maleNum;
//    onFlag = ,
@property (nonatomic, assign) NSInteger
onFlag;
//    cover = ,
@property (nonatomic, copy) NSString *cover;
//    subsidyPrice = ,
@property (nonatomic, assign) double subsidyPrice;
//    emchatGroupId = ,
@property (nonatomic, copy) NSString *emchatGroupId;
//    linkTicketUrl = ,
@property (nonatomic, copy) NSString *linkTicketUrl;
@property (nonatomic, strong) NSDictionary *destination;
//    destination = {
//        district = 玄武区,
//        detail = ,
//        province = 江苏省,
//        city = 南京市,
//        street = 玄武大道
//    },
//    members = [
//    ],
@property (nonatomic, strong) NSArray *members;
//    priceDesc = 测试PriceDescription,
@property (nonatomic, copy) NSString *priceDesc;
//    officialActivityId = 561bb0280cf2429fb48e86c2,
@property (nonatomic, copy) NSString *officialActivityId;
//    deleteFlag = ,
@property (nonatomic, assign) BOOL deleteFlag;
//    femaleLimit = 20,
@property (nonatomic, assign) NSUInteger femaleLimit;
//    end = 1444662636453,
@property (nonatomic, assign) long long end;
//    photos = [
//    ],
@property (nonatomic, strong) NSArray *photos;
//    extraDesc = ,
@property (nonatomic, copy) NSString *extraDesc;
//    start = 1444652636457,
@property (nonatomic, assign) long long start;
//    price = 200,
@property (nonatomic, assign) double price;
//    createTime = 1444655144431,?
@property (nonatomic, assign) long long createTime;

//    userId = 561ba2d60cf2429fb48e86bd
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy, readonly) NSAttributedString *priceText;
@end
