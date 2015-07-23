//
//  CPDiscussStatus.h
//  CarPlay
//
//  Created by 公平价 on 15/7/23.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDiscussStatus : NSObject

// 评论者年龄
@property (nonatomic,copy) NSString *age;

// 评论者内容
@property (nonatomic,copy) NSString *comment;

// 评论者性别
@property (nonatomic,copy) NSString *gender;

// 评论者昵称
@property (nonatomic,copy) NSString *nickname;

// 评论者头像
@property (nonatomic,copy) NSString *photo;

// 评论时间
@property (nonatomic, assign) long long publishTime;
@property (nonatomic,copy) NSString *publishTimeStr;

// 答复者id
@property (nonatomic,copy) NSString *replyUserId;

// 答复者昵称
@property (nonatomic,copy) NSString *replyUserName;

// 评论者ID
@property (nonatomic,copy) NSString *userId;


@end
