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
#define CPNewActivityMsgEditNotifycation @"CPNewActivityMsgEditNotifycation"
#define CPNewActivityMsgEditInfo @"CPNewActivityMsgEditInfo"
@class CPActivityApplyModel;
@interface CPActivityApplyCell : UITableViewCell
@property (nonatomic, strong) CPActivityApplyModel *model;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL checked;
@end
