//
//  CPNewMessageCell.h
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CPNewMsgEditNotifycation @"CPNewMsgEditNotifycation"
#define CPNewMsgEditInfo @"CPNewMsgEditInfo"

@class CPNewMsgModel;
@interface CPNewMessageCell : UITableViewCell
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) CPNewMsgModel *model;
@property (nonatomic, assign) BOOL checked;
@end
