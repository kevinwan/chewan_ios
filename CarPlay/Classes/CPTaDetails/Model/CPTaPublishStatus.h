//
//  CPTaPublishStatus.h
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPHomeUser.h"

@interface CPTaPublishStatus : NSObject

// 活动ID
@property (nonatomic,copy) NSString *activityId;

// 配图
@property (nonatomic, strong) NSArray *cover;

// 正文
@property (nonatomic,copy) NSString *introduction;

// 地点
@property (nonatomic,copy) NSString *location;

// 成员头像
@property (nonatomic,strong) NSArray *members;

// 参与成员个数
@property (nonatomic, assign) NSUInteger membersCount;

// 付费方式
@property (nonatomic,copy) NSString *pay;

// 开始时间
@property (nonatomic,assign) long long startDate;
@property (nonatomic,copy) NSString *startDateStr;

// 发布日期
@property (nonatomic,copy) NSString *publishDate;



/** 活动创建时间 */
@property (nonatomic, assign) long long publishTime;
@property (nonatomic,copy) NSString *publishTimeStr;


/** 活动时间 */
@property (nonatomic, assign) long long start;
@property (nonatomic,copy) NSString *startStr;

/** 活动是否在进行中 */
@property (nonatomic,assign) BOOL isActiveStart;


/** 总座位数 */
@property (nonatomic, copy) NSString *totalSeat;

/** 可用座位数 */
@property (nonatomic, copy) NSString *holdingSeat;

/** 活动类型 */
@property (nonatomic, copy) NSString *type;

/** 是否为活动创建者 */
@property (nonatomic,assign) NSInteger isOrganizer;

/** 是否为活动成员 */
@property (nonatomic,assign) NSInteger isMember;

/** 是否已结束 */
@property (nonatomic,assign) NSInteger isOver;

/** 活动作者的用户信息字段 */
@property (nonatomic, strong) CPHomeUser *organizer;




@end
