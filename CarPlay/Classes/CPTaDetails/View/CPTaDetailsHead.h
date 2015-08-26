//
//  CPTaDetailsHead.h
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPTaDetailsStatus.h"

typedef void(^StatusSelected)(NSInteger ignore,NSString *selectStr);

@interface CPTaDetailsHead : UIView

@property (nonatomic,strong) CPTaDetailsStatus *taStatus;

// 回调函数
@property (nonatomic,copy) StatusSelected statusSelected;

// 创建headview
+ (instancetype)headView;

@end
