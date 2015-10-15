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
//    title = 测试官方活动Title,
@property (nonatomic, copy) NSString *title;
//    instruction = 测试官方活动Instruction,
@property (nonatomic, copy) NSString *instruction;

//    destPoint = {
//        longitude = 0,
//        latitude = 0
//    },
@property (nonatomic, strong) NSDictionary *destPoint;

//    cover = ,
@property (nonatomic, copy) NSString *cover;

@property (nonatomic, strong) NSDictionary *destination;
//    destination = {
//        district = 玄武区,
//        detail = 具体地点,
//        province = 江苏省,
//        city = 南京市,
//        street = 玄武大道
//    },
@property (nonatomic, copy) NSString *activityId;
//   covers
@property (nonatomic, strong) NSArray *covers;
//    start = 1444652636457,
@property (nonatomic, assign) long long start;

//    end = 1444662636453,
@property (nonatomic, assign) long long end;
//    price = 200,
@property (nonatomic, assign) double price;
//    subsidyPrice = ,
@property (nonatomic, assign) double subsidyPrice;
//    priceDesc = 测试PriceDescription,
@property (nonatomic, copy) NSString *priceDesc;
@property (nonatomic, copy, readonly) NSAttributedString *priceText;
@end
