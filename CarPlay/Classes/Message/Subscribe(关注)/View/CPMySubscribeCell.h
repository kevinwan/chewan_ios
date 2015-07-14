//
//  CPMyPublishCell.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  我的关注cell

#import <UIKit/UIKit.h>
@class CPMySubscribeFrameModel;
@interface CPMySubscribeCell : UITableViewCell

@property (nonatomic, strong) CPMySubscribeFrameModel *frameModel;

@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
