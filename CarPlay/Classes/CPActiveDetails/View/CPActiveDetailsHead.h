//
//  CPCPActiveDetailsHeader.h
//  CPActiveDetailsDemo
//
//  Created by 公平价 on 15/7/3.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Router.h"
#import "CPActiveStatus.h"



typedef void (^PictureDidSelected)(CPActiveStatus *status,NSIndexPath *path, NSArray *srcView);
typedef void(^GoTaDetails)();


@class CPActiveStatus;

@interface CPActiveDetailsHead : UIView

// 是否为官方活动
@property (nonatomic,assign) BOOL isOfficialActivity;

// 回调函数
@property (nonatomic,copy) GoTaDetails goTaDetails;
@property (nonatomic,copy) PictureDidSelected pictureDidSelected;

// 活动详情
@property (nonatomic,strong) CPActiveStatus *activeStatus;

// 创建headview
+ (instancetype)headView:(id)owner;

- (CGFloat)xibHeightWithActiveStatus:(CPActiveStatus *)activeStatus;

@end
