//
//  CPActivityModel.h
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPUser.h"
@interface CPActivityModel : NSObject

//"activityId": "0193a45f-bd62-457e-b262-5f185a94a781",
@property (nonatomic, copy) NSString *activityId;
//"type": "看电影",
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy, readonly) NSString *title;
//"destination":{
//    "province": "江苏省",
//    "city": "南京市",
//    "district": "玄武区",
//    "street": "玄武湖街道"
//},
@property (nonatomic, strong) NSDictionary *destination;
@property (nonatomic, strong) NSDictionary *start;
//"start": {"birthday":{"date":22,"day":6,"hours":13,"minutes":18,"month":8,"seconds":3,"time":653980683959,"timezoneOffset":-480,"year":90}},
//"pay": "AA制",
@property (nonatomic, copy) NSString *pay;
// 活动的状态
@property (nonatomic, assign) NSInteger applyFlag;
//"transfer": true,
@property (nonatomic, assign) BOOL transfer;
//"distance": 20,
@property (nonatomic, assign) NSUInteger distance;

@property (nonatomic, copy, readonly) NSString *distanceStr;
// organizer 组织者
@property (nonatomic, strong) CPUser *organizer;
@end
