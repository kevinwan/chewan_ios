//
//  CPCreatActivityCell.h
//  CarPlay
//
//  Created by chewan on 15/7/18.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCreatActivityCell : UITableViewCell

/**
 *  记录cell点击后的操作
 */
@property (nonatomic, copy) void (^operation)();

/**
 *  目标控制器
 */
@property (nonatomic, assign) Class destClass;

@end
