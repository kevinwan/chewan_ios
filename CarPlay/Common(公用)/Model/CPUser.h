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

//    "gender": "男",
@property (nonatomic, copy) NSString *gender;
//    "age": 25,
@property (nonatomic, assign) NSUInteger age;
//    "role": "普通用户",
@property (nonatomic, copy) NSString *role;
//      用户头像
@property (nonatomic, copy) NSString *avatar;
//    "drivingYears": 5,
@property (nonatomic, assign) NSUInteger drivingYears;
//    "photoAuthStatus": 认证通过,
@property (nonatomic, copy) NSString *photoAuthStatus;
//    "licenseAuthStatus": 认证通过,
@property (nonatomic, copy) NSString *licenseAuthStatus;
//    "car":{   "logo":    "model": "奥迪A4L"}
@property (nonatomic, strong) CPCar *car;

@end
