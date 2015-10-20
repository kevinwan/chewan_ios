//
//  CPActivityDetailModel.h
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPActivityDetailModel : NSObject

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
@property (nonatomic, strong) CPUser *organizer;
//    onFlag = 1,
@property (nonatomic, assign) BOOL onFlag;

//    cover = {
//        uploadTime = ,
//        id = d386e476-3d01-4d35-8d1e-912463fd1d98,
//        key = asset/activity/cover/d386e476-3d01-4d35-8d1e-912463fd1d98/cover.jpg,
//        url =
//    },
//    subsidyPrice = 58,
//    emchatGroupId = 117409959217463816,
@property (nonatomic, copy) NSString *emchatGroupId;
//    linkTicketUrl = http://www.baidu.com,
@property (nonatomic, copy) NSString *linkTicketUrl;

@property (nonatomic, strong) NSArray *members;
//    members = ,
//    priceDesc = ,
//    officialActivityId = 561f723b0cf24f3b99211d0f,
@property (nonatomic, copy) NSString *officialActivityId;
//    deleteFlag = 0,
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, strong) NSArray *photos;
//    photos = ,
//    extraDesc = 测试官方活动补充说明,
@property (nonatomic, copy) NSString *extraDesc;

@property (nonatomic, assign) long long createTime;
//    userId = 561ba2d60cf2429fb48e86bd
@property (nonatomic, copy) NSString *userId;
//},
//{
//    description = 活动介绍2，测试官方活动,
//    totalLimit = 200,
//    femaleNum = 0,
//    title = 南京欢迎你，测试官方活动,
//    covers = [
//              http://7xknzo.com1.z0.glb.clouddn.com/asset/activity/cover/46f1dd9a-f1f2-4767-8f85-600d106f8207/cover.jpg
//              ],
//    instruction = 活动介绍2，测试官方活动,
//    maleLimit = ,
//    maleNum = 0,
//    onFlag = 1,
//    organizer = {
//        avatar = http://cwapi.gongpingjia.com:8080/v2/photos/asset/user/867b8ca6-c472-4d86-a5ea-c18c007778f2/avatar.jpg,
//        nickname = 车玩官方
//    },
//    cover = {
//        uploadTime = ,
//        id = 46f1dd9a-f1f2-4767-8f85-600d106f8207,
//        key = asset/activity/cover/46f1dd9a-f1f2-4767-8f85-600d106f8207/cover.jpg,
//        url =
//    },
//    subsidyPrice = 100,
//    emchatGroupId = 117388448544850332,
//    linkTicketUrl = http://www.baidu.com,
//    destination = {
//        district = ,
//        detail = 徐庄,
//        province = 江苏省,
//        city = 南京市,
//        street =
//    },
//    members = ,
//    priceDesc = ,
//    officialActivityId = 561f5eaa0cf2a1b735efa50a,
//    deleteFlag = 0,
//    femaleLimit = ,
//    nowJoinNum = 0,
//    end = 1446137400000,
//    photos = ,
//    extraDesc = 活动补充说明2，测试官方活动,
//    start = 1444841400000,
//    price = 150,
//    limitType = 1,
//    createTime = 1444896426962,
//    userId = 561ba2d60cf2429fb48e86bd
//},
//{
//    description = 活动内容，测试官方活动,
//    totalLimit = ,
//    femaleNum = 0,
//    title = 活动标题，测试官方活动,
//    covers = [
//              http://7xknzo.com1.z0.glb.clouddn.com/asset/activity/cover/24e06445-7e03-4e3a-8717-7678ab364d79/cover.jpg
//              ],
//    instruction = 活动介绍，测试官方活动,
//    maleLimit = 20,
//    maleNum = 0,
//    onFlag = 1,
//    organizer = {
//        avatar = http://cwapi.gongpingjia.com:8080/v2/photos/asset/user/867b8ca6-c472-4d86-a5ea-c18c007778f2/avatar.jpg,
//        nickname = 车玩官方
//    },
//    cover = {
//        uploadTime = ,
//        id = 24e06445-7e03-4e3a-8717-7678ab364d79,
//        key = asset/activity/cover/24e06445-7e03-4e3a-8717-7678ab364d79/cover.jpg,
//        url =
//    },
//    subsidyPrice = 15,
//    emchatGroupId = 117387001983926844,
//    linkTicketUrl = http://cwapi.gongpingjia.com:8080,
//    destination = {
//        district = ,
//        detail = 徐庄软件园,
//        province = 江苏省,
//        city = 南京市,
//        street = 
//    },
//    members = ,
//    priceDesc = ,
//    officialActivityId = 561f5d5b0cf2a1b735efa508,
//    deleteFlag = 0,
//    femaleLimit = 25,
//    nowJoinNum = 0,
//    end = 1445618640000,
//    photos = ,
//    extraDesc = 活动补充说明，测试官方活动,
//    start = 1443672000000,
//    price = 100,
//    limitType = 2,
//    createTime = 1444896091189,
//    userId = 561ba2d60cf2429fb48e86bd
//}
//],
@end
