//
//  CPNewMessageCell.h
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPNewMsgModel;
@interface CPNewMessageCell : UITableViewCell
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) CPNewMsgModel *model;
@end
