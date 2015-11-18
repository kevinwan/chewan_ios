//
//  CPCareUser.h
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPUser.h"

@interface CPCareUser : NSObject

// 用户id
@property (nonatomic,copy) NSString *userId;

// 用户昵称
@property (nonatomic,copy) NSString *nickname;

// 性别
@property (nonatomic,copy) NSString *gender;

// 年龄
@property (nonatomic,assign) NSInteger age;

// 头像
@property (nonatomic,copy) NSString *avatar;

// 距离
@property (nonatomic,assign) NSInteger distance;

// 头像认证状态
@property (nonatomic,copy) NSString *photoAuthStatus;

// 车主认证状态
@property (nonatomic,copy) NSString *licenseAuthStatus;

//用户的车辆信息
@property (nonatomic, strong) CPCar *car;
@end
