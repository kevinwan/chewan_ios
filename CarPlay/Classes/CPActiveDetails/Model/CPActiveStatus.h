//
//  CPActiveStatus.h
//  CarPlay
//
//  Created by 公平价 on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPActiveUser.h"
#import "CPActivePhoto.h"

@interface CPActiveStatus : NSObject

/** 字符串型的活动ID */
@property (nonatomic, copy) NSString *activityId;

/** 活动信息内容 */
@property (nonatomic, copy) NSString *introduction;

/** 活动创建时间 */
@property (nonatomic, assign) long long publishTime;
@property (nonatomic,copy) NSString *publishTimeStr;


/** 活动开始时间 */
@property (nonatomic, assign) long long start;
@property (nonatomic,copy) NSString *startStr;

/** 活动结束时间 */
@property (nonatomic, assign) long long end;
@property (nonatomic,copy) NSString *endStr;

/** 活动地点 */
@property (nonatomic, copy) NSString *location;

/** 付费类型 */
@property (nonatomic, copy) NSString *pay;


/** 活动类型 */
@property (nonatomic, copy) NSString *type;


/** 活动作者的用户信息字段 */
@property (nonatomic, strong) CPActiveUser *organizer;


/** 是否为活动创建者 */
@property (nonatomic,assign) NSInteger isOrganizer;

/** 是否为活动成员 */
@property (nonatomic,assign) NSInteger isMember;

// 是否已收藏
@property (nonatomic,assign) NSInteger isSubscribed;

/** 活动配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *cover;

/** 头像配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *members;

/** 经度 */
@property (nonatomic, assign) double longitude;

/** 纬度 */
@property (nonatomic, assign) double latitude;

/** 城市 */
@property (nonatomic, copy) NSString *city;

/** 省 */
@property (nonatomic, copy) NSString *province;

/** 县、区*/
@property (nonatomic, copy) NSString *district;

/** 座位数*/
@property (nonatomic, copy) NSString *seatInfo;

@end
