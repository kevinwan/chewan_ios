//
//  CPMypublishModel.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

// 点击了聊天按钮
#define ChatButtonClickNotifyCation @"ChatButtonClickNotifyCation"
#define ChatButtonClickInfo @"ChatButtonClickInfo"

// 点击了参与人数按钮
#define JoinPersonClickNotifyCation @"JoinPersonClickNotifyCation"
#define JoinPersonClickInfo @"JoinPersonClickInfo"

#define TimeStampFont     [UIFont systemFontOfSize:16]
#define contentFont     [UIFont systemFontOfSize:16]

@class CPOrganizer,Data;
@interface CPMySubscribeModel : NSObject

// 记录cell的行号
@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, assign) long long start;

@property (nonatomic, copy) NSString *startStr;

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) NSInteger totalSeat;

@property (nonatomic, copy) NSString *seatStr;

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *pay;

@property (nonatomic, copy) NSString *location;

// sixLocation 只有六个字的location
@property (nonatomic, copy) NSString *sixLocation;

@property (nonatomic, strong) NSArray *cover;

@property (nonatomic, assign) long long publishTime;

// 发布时间的str
@property (nonatomic, copy) NSString *publishTimeStr;

@property (nonatomic, assign) NSInteger holdingSeat;

@property (nonatomic, strong) CPOrganizer *organizer;

// 是成员
@property (nonatomic, assign) NSInteger isMember;

// 是组织者
@property (nonatomic, assign) NSInteger isOrganizer;

@end

@interface CPOrganizer : NSObject

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger drivingExperience;

// 信息的描述
@property (nonatomic, copy) NSString *descStr;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *carBrandLogo;

@property (nonatomic, copy) NSString *carModel;

@property (nonatomic, assign) BOOL isMan;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *backGroudImgUrl;

@property (nonatomic, copy) NSString *headImgUrl;

@property (nonatomic, copy) NSString *headImgId;

@property (nonatomic, copy) NSArray *albumPhotos;

@property (nonatomic, assign) NSInteger postNumber;

@property (nonatomic, assign) NSInteger subscribeNumber;

@property (nonatomic, assign) NSInteger joinNumber;

@property (nonatomic, assign) NSInteger isAuthenticated;

@property (nonatomic, copy) NSString *cityAndDistrict;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *district;

@property (nonatomic, assign) NSInteger brithYear;

@property (nonatomic, assign) NSInteger birthMonth;

@property (nonatomic, assign) NSInteger birthDay;
@end
