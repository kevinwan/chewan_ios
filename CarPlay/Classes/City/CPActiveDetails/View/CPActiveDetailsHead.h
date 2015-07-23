//
//  CPCPActiveDetailsHeader.h
//  CPActiveDetailsDemo
//
//  Created by 公平价 on 15/7/3.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPActiveStatus;

@interface CPActiveDetailsHead : UIView
// 活动详情
@property (nonatomic,strong) CPActiveStatus *activeStatus;

// 创建headview
+ (instancetype)headView;

@end
