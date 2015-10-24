//
//  CPMyDateModel.h
//  CarPlay
//
//  Created by chewan on 10/23/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPUser.h"
@interface CPMyDateModel : NSObject

//    invitedUserId = 561b8a040cf2429fb48e86b0,
@property (nonatomic, copy) NSString *invitedUserId;
//    applyUserId = 561f755b0cf24f3b99211d12,
@property (nonatomic, copy) NSString *applyUserId;
@property (nonatomic, copy) NSString *appointmentId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *activityCategory;
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
@property (nonatomic, assign) long long start;
//"start": {"birthday":{"date":22,"day":6,"hours":13,"minutes":18,"month":8,"seconds":3,"time":653980683959,"timezoneOffset":-480,"year":90}},
//"pay": "AA制",
@property (nonatomic, copy) NSString *pay;
// 活动的状态
@property (nonatomic, assign) NSInteger applyFlag;
//"transfer": true,
@property (nonatomic, assign) BOOL transfer;

@property (nonatomic, copy, readonly) NSString *distanceStr;

@property (nonatomic, assign) double distance;
// organizer 组织者
@property (nonatomic, strong) CPUser *applicant;
@end
