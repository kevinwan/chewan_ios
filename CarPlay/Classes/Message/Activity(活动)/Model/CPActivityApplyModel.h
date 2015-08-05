//
//  CPActivityApplyModel.h
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPActivityApplyModel : NSObject

@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, strong) NSNumber *age;

@property (nonatomic, strong) NSNumber *seat;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *carBrandLogo;

@property (nonatomic, assign) NSInteger drivingExperience;

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, copy) NSString *carModel;

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *content;

/**
 *  显示的内容
 */
@property (nonatomic, copy) NSAttributedString *text;

/**
 *  显示seat的文本
 */
@property (nonatomic, copy) NSAttributedString *seatText;

/**
 *  是否同意
 */
@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, assign) BOOL isChecked;

@end
