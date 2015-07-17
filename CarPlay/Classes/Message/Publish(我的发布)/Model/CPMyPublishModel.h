//
//  CPMypublishModel.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TimeStampFont     [UIFont systemFontOfSize:16]
#define contentFont     [UIFont systemFontOfSize:16]
@class CPOrganizer;
@interface CPMyPublishModel : NSObject
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

@property (nonatomic, strong) NSArray *cover;

@property (nonatomic, assign) long long publishTime;
// 发布时间的str
@property (nonatomic, copy) NSString *publishTimeStr;

@property (nonatomic, assign) NSInteger availableSeat;

@property (nonatomic, strong) CPOrganizer *organizer;

@end
