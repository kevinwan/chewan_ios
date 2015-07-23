//
//  CPLocationModel.h
//  CarPlay
//
//  Created by chewan on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  记录活动地点的Model 

#import <Foundation/Foundation.h>

@interface CPLocationModel : NSObject
//“location”:”$location”,
@property (nonatomic, copy) NSString *location;
//“longitude”:”$longitude”,
@property (nonatomic, strong) NSNumber *longitude;
//“latitude”:”$latitude”,
@property (nonatomic, strong) NSNumber *latitude;
//“city”:”$city”,
@property (nonatomic, copy) NSString *city;
// 区
@property (nonatomic, copy) NSString *district;
@end
