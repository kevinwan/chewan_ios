//
//  CPCreatActivityModel.h
//  CarPlay
//
//  Created by chewan on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCreatActivityModel : NSObject
//“type”:”$type”,
@property (nonatomic, copy) NSString *type;
//“description”:”$description”,
@property (nonatomic, copy) NSString *introduction;
//“cover”:”$cover”,   cover 是数组
@property (nonatomic, strong) NSArray *cover;
//“location”:”$location”,
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *address;
//“longitude”:”$longitude”,
@property (nonatomic, assign) double longitude;
//“latitude”:”$latitude”,
@property (nonatomic, assign) double latitude;
//“start”:”$start”,
@property (nonatomic, assign) NSTimeInterval start;
//“end”:”$end”,
@property (nonatomic, assign) NSTimeInterval end;
//“city”:”$city”,
@property (nonatomic, copy) NSString *city;
//“pay”:”$pay”,
@property (nonatomic, copy) NSString *pay;
//“seat”:”$seat”
@property (nonatomic, assign) int seat;
/**
 *  省份
 */
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *activityId;
@end
