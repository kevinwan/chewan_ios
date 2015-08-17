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
    
    if (showUnreadCount) {
        self.redUnreadLabelPoint.hidden = NO;
        self.unreadLabel.hidden = YES;
    }else{
        self.redUnreadLabelPoint.hidden = YES;
        self.unreadLabel.hidden = NO;
    }
}

@end
