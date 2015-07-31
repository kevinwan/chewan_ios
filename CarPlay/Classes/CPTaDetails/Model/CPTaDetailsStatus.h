//
//  CPTaDetailsStatus.h
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPTaDetailsStatus : NSObject

// 年龄
@property (nonatomic,copy) NSString *age;

// 轮播器图片
@property (nonatomic, strong) NSArray *albumPhotos;

// 车标
@property (nonatomic,copy) NSString *carBrandLogo;

// 车型
@property (nonatomic,copy) NSString *carModel;

// 驾龄
@property (nonatomic,copy) NSString *drivingExperience;

// 性别
@property (nonatomic,copy) NSString *gender;

// 关注(1代表已关注， 0代表未关注)
@property (nonatomic,copy) NSString *isSubscribed;

// 参与数
@property (nonatomic,copy) NSString *joinNumber;

// "TA"或者"我"
@property (nonatomic,copy) NSString *label;

// 昵称
@property (nonatomic,copy) NSString *nickname;

// 头像
@property (nonatomic,copy) NSString *photo;

// 发布数
@property (nonatomic,copy) NSString *postNumber;

// 关注数
@property (nonatomic,copy) NSString *subscribeNumber;

// 用户id
@property (nonatomic,copy) NSString *userId;


@end
