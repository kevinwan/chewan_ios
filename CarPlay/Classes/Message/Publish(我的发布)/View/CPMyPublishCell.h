//
//  CPMyPublishCell.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPMyPublishFrameModel;
@interface CPMyPublishCell : UITableViewCell

@property (nonatomic, strong) CPMyPublishFrameModel *frameModel;

@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
