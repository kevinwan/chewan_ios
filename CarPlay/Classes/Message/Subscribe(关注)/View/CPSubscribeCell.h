//
//  CPSubscribeCell.h
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  我关注的人的cell

#import <UIKit/UIKit.h>

#define CPCancleSubscribeNotify @"CPCancleSubscribeNotify"
#define CPCancleSubscribeInfo   @"CPCancleSubscribeInfo"

@class CPOrganizer;
@interface CPSubscribeCell : ZYTableViewCell
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, strong) CPOrganizer *model;
@end
