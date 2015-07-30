//
//  CPDiscussCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/24.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPDiscussStatus.h"

@interface CPDiscussCell : UITableViewCell

@property (nonatomic,strong) CPDiscussStatus *discussStatus;

+ (NSString *)identifier;

// 返回一行有多高
- (CGFloat)cellHeightWithDiscussStatus:(CPDiscussStatus *)discussStatus;

@end
