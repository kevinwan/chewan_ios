//
//  CPChatListCell.h
//  CarPlay
//
//  Created by chewan on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYTableViewCell.h"
#import "CPHomeMsgModel.h"

@interface CPChatListCell : ZYTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (nonatomic, strong) UILabel *redUnreadLabelPoint;
@property (nonatomic, strong) UILabel *unreadLabel;
@property (nonatomic, assign) BOOL showUnreadCount;
@property (nonatomic, strong) CPHomeMsgModel *model;
@end
