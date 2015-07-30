//
//  CPActivityApplyCell.h
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CPActivityApplyNotification @"CPActivityApplyNotification"
#define CPActivityApplyInfo @"CPActivityApplyInfo"

@class CPActivityApplyModel;
@interface CPActivityApplyCell : UITableViewCell
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, strong) CPActivityApplyModel *model;
@end
