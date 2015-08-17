//
//  CPMypublishModel.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MyPublishToPlayNotify @"MyPublishToPlayNotify"
#define MyPublishToPlayInfo   @"MyPublishToPlayInfo"

#define MyJoinPersonNotify    @"MyJoinPersonNotify"
#define MyJoinPersonInfo      @"MyJoinPersonInfo"

#define TimeStampFont     [UIFont systemFontOfSize:16]
#define contentFont     [UIFont systemFontOfSize:16]
@class CPOrganizer;
@interface CPMyPublishModel : NSObject

@property (nonatomic, assign) NSTimeInterval startDate;

// 创建活动的时间戳
@property (nonatomic, copy) NSString *startDateStr;

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) NSInteger totalSeat;

@property (nonatomic, copy) NSString *seatStr;

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *pay;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, strong) NSArray *cover;

// 发布时间的str
@property (nonatomic, copy) NSString *publishDate;

@property (nonatomic, assign) NSInteger availableSeat;

@property (nonatomic, strong) CPOrganizer *organizer;

@property (nonatomic, assign) NSInteger isOver;

@property (nonatomic, assign) NSUInteger row;

@end
