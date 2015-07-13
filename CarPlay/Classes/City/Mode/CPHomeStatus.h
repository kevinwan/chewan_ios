//
//  CPHomeStatus.h
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPHomeUser.h"
#import "CPHomePhoto.h"

@interface CPHomeStatus : NSObject

/** 字符串型的活动ID */
@property (nonatomic, copy) NSString *idstr;

/** 活动信息内容 */
@property (nonatomic, copy) NSString *text;

/** 活动创建时间 */
@property (nonatomic, copy) NSString *publishTime;


/** 活动时间 */
@property (nonatomic, copy) NSString *startTime;

/** 活动地点 */
@property (nonatomic, copy) NSString *location;

/** 总座位数 */
@property (nonatomic, copy) NSString *totalSeat;

/** 可用座位数 */
@property (nonatomic, copy) NSString *availableSeat;


/** 付费类型 */
@property (nonatomic, copy) NSString *payType;

/** 活动类型 */
@property (nonatomic, copy) NSString *activeType;


/** 活动作者的用户信息字段 */
@property (nonatomic, strong) CPHomeUser *user;


/** 活动配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

@end
