//
//  CPActiveUser.h
//  CarPlay
//
//  Created by 公平价 on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPActiveUser : NSObject

// id
@property (nonatomic,copy) NSString *userId;

// 年龄
@property (nonatomic,copy) NSString *age;

// 车标
@property (nonatomic,copy) NSString *carBrandLogo;

// 车型
@property (nonatomic,copy) NSString *carModel;

// 驾龄
@property (nonatomic,copy) NSString *drivingExperience;

// 性别
@property (nonatomic,copy) NSString *gender;

// 昵称
@property (nonatomic,copy) NSString *nickname;

// 头像
@property (nonatomic,copy) NSString *photo;

// 是不是官方成员
@property (nonatomic, copy) NSString *role;

@end
