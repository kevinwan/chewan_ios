//
//  CPOfficialActivityCell.h
//  CarPlay
//
//  Created by 公平价 on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPHomeStatus.h"

@interface CPOfficialActivityCell : UITableViewCell

// 存储官方cell数据
@property (nonatomic,strong) CPHomeStatus *homeStatus;

// 主动加载cell方法
+ (instancetype)officialActivityCell;

@end
