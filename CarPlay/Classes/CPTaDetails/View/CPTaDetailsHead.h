//
//  CPTaDetailsHead.h
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTaDetailsStatus.h"

@interface CPTaDetailsHead : UIView

@property (nonatomic,strong) CPTaDetailsStatus *taStatus;

// 创建headview
+ (instancetype)headView;

@end
