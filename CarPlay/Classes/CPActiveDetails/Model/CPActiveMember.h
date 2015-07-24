//
//  CPActiveMember.h
//  CarPlay
//
//  Created by 公平价 on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPActiveMember : NSObject

// 用户昵称
@property (nonatomic,copy) NSString *nickname;
// 用户头像
@property (nonatomic,copy) NSString *photo;
// 用户id
@property (nonatomic,copy) NSString *userId;

// 当前member
@property (nonatomic,assign) NSInteger currentMember;

// 头像总个数
@property (nonatomic,assign) NSInteger membersCount;

@end
