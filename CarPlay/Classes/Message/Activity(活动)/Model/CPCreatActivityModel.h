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
//“longitude”:”$longitude”,
@property (nonatomic, copy) NSString *longitude;
//“latitude”:”$latitude”,
@property (nonatomic, copy) NSString *latitude;
//“start”:”$start”,
@property (nonatomic, copy) NSString *start;
//“end”:”$end”,
@property (nonatomic, copy) NSString *end;
//“city”:”$city”,
@property (nonatomic, copy) NSString *city;
//“pay”:”$pay”,
@property (nonatomic, copy) NSString *pay;
//“seat”:”$seat”
@property (nonatomic, copy) NSString *seat;
@end
