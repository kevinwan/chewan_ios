//
//  CPUser.h
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCar : NSObject
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *model;
@end

@interface CPUser : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *phone;

//    "gender": "男",
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, assign) BOOL isMan;

//    "age": 25,
@property (nonatomic, assign) NSUInteger age;

@property (nonatomic, assign) long brithDay;
//    "role": "普通用户",
@property (nonatomic, copy) NSString *role;
//      用户头像url
@property (nonatomic, copy) NSString *avatar;
//      用户头像Id
@property (nonatomic, copy) NSString *avatarId;

//    "drivingYears": 5,
@property (nonatomic, assign) NSUInteger drivingYears;
//    "photoAuthStatus": 认证通过,
@property (nonatomic, copy) NSString *photoAuthStatus;
//    "licenseAuthStatus": 认证通过,
@property (nonatomic, copy) NSString *licenseAuthStatus;
//    "car":{   "logo":    "model": "奥迪A4L"}
@property (nonatomic, strong) CPCar *car;

@property (nonatomic, copy) NSString *driverLicense;
// 是不是被关注
@property (nonatomic, assign) BOOL subscribeFlag;

@property (nonatomic, strong) NSArray *album;
//个人资料完成程度1-100
@property (nonatomic, assign) NSUInteger completion;
@end
