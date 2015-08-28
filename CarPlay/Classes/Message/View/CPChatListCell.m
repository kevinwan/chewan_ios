//
//  CPChatListCell.m
//  CarPlay
//
//  Created by chewan on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPChatListCell.h"

@interface CPChatListCell ()
@end

@implementation CPChatListCell

- (void)awakeFromNib
{
    _redUnreadLabelPoint = [[UILabel alloc] initWithFrame:CGRectMake(47.5, 10, 9, 9)];
    _redUnreadLabelPoint.backgroundColor = [Tools getColor:@"fc6e51"];
    _redUnreadLabelPoint.layer.cornerRadius = 4.5;
    _redUnreadLabelPoint.clipsToBounds = YES;
    _redUnreadLabelPoint.hidden=YES;
    [self.contentView addSubview:_redUnreadLabelPoint];
    
    _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 15, 15)];
    _unreadLabel.backgroundColor = [Tools getColor:@"fc6e51"];
    _unreadLabel.textColor = [UIColor whiteColor];
    
    _unreadLabel.textAlignment = NSTextAlignmentCenter;
    _unreadLabel.font = [UIFont systemFontOfSize:11];
    _unreadLabel.layer.cornerRadius = 7.5;
    _unreadLabel.clipsToBounds = YES;
    [self.contentView addSubview:_unreadLabel];
}

- (void)setShowUnreadCount:(BOOL)showUnreadCount
{
    _showUnreadCount = showUnreadCount;
    
    self.unreadLabel.hidden = YES;
    if (showUnreadCount) {
        self.redUnreadLabelPoint.hidden = NO;
    }else{
        self.redUnreadLabelPoint.hidden = YES;
    }
}

- (void)setModel:(CPHomeMsgModel *)model
{
    _model = model;
    
    self.redUnreadLabelPoint.hidden = YES;
    
    if (model.createTime) {
        self.timeLabel.text = model.timeStr;
    }else{
        self.timeLabel.text = @"";
    }
    self.msgLabel.attributedText = model.contentAttr;
    if (model.isShowUnread) {
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = model.unreadCount;
    }else{
        self.unreadLabel.hidden = YES;
    }
    self.titleNameLabel.text = model.title;
    [self.iconView setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
}

@end
