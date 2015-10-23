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
@property (nonatomic, copy, readonly) NSAttributedString  *titleAttrText;
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
@property (nonatomic, copy) NSString *officialActivityId;
//   covers
@property (nonatomic, strong) NSArray *covers;
//    start = 1444652636457,
@property (nonatomic, assign) long long start;
@property (nonatomic, copy) NSString *startStr;
//    end = 1444662636453,
@property (nonatomic, assign) long long end;
@property (nonatomic, copy) NSString *endStr;
//    price = 200,
@property (nonatomic, assign) double price;
//    subsidyPrice = ,
@property (nonatomic, assign) double subsidyPrice;
//    priceDesc = 测试PriceDescription,
@property (nonatomic, copy) NSString *priceDesc;
@property (nonatomic, copy, readonly) NSAttributedString *priceText;
//"limitType" : 2,
@property (nonatomic, assign) NSUInteger limitType;
//"totalLimit" : 300,
@property (nonatomic, assign) NSUInteger totalLimit;
//"nowJoinNum" : 30,
@property (nonatomic, assign) NSUInteger nowJoinNum;
@property (nonatomic, copy, readonly) NSAttributedString *joinPersonText;
//"maleLimit" : 30,
@property (nonatomic, assign) NSUInteger maleLimit;
//"maleNum" : 10,
@property (nonatomic, assign) NSUInteger maleNum;
//"femaleLimit" : 30,
@property (nonatomic, assign) NSUInteger femaleLimit;
//"femaleNum" : 3,
@property (nonatomic, assign) NSUInteger femaleNum;
@property (nonatomic, copy) NSString *extraDesc;
@property (nonatomic, strong) CPUser *organizer;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, assign) BOOL isMember;
@end

@interface CPPartMember : CPUser
@property (nonatomic, assign) NSUInteger acceptCount;
@property (nonatomic, strong) NSArray *acceptMembers;
@property (nonatomic, assign) BOOL acceptMe;
@property (nonatomic, assign) NSUInteger invitedCount;
@property (nonatomic, copy)   NSAttributedString *invitedCountStr;
@end
