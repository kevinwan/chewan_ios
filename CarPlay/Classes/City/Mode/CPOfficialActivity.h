//
//  CPOfficialActivity.h
//  CarPlay
//
//  Created by 公平价 on 15/8/18.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPOfficialActivity : NSObject

// 官方活动的id
@property (nonatomic,copy) NSString *activityId;

// 官方活动标题
@property (nonatomic,copy) NSString *title;

// 官方活动的简介
@property (nonatomic,copy) NSString *content;

// 官方活动的Logo
@property (nonatomic,copy) NSString *logo;

// 官方活动的宣传海报url
@property (nonatomic,copy) NSString *cover;

// 官方活动的报名截止时间
@property (nonatomic,assign) long long end;
@property (nonatomic,copy) NSString *endStr;

@end
