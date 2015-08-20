//
//  CPHomeMsgModel.h
//  CarPlay
//
//  Created by chewan on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPHomeMsgModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSAttributedString *contentAttr;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *unreadCount;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BOOL isShowUnread;
@end
