//
//  CPNewMsgModel.h
//  CarPlay
//
//  Created by chewan on 15/7/29.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNewMsgModel : NSObject

@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger drivingExperience;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *carBrandLogo;

@property (nonatomic, copy) NSString *carModel;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, assign) BOOL isMan;

@end
