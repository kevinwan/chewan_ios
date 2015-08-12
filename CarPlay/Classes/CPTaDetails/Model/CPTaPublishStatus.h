//
//  CPTaPublishStatus.h
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

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

// 付费方式
@property (nonatomic,copy) NSString *pay;

// 开始时间
@property (nonatomic,assign) long long startDate;
@property (nonatomic,copy) NSString *startDateStr;

// 发布日期
@property (nonatomic,copy) NSString *publishDate;


@end
