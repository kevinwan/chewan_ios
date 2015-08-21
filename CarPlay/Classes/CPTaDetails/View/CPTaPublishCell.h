//
//  CPTaPublishCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTaPublishStatus.h"


typedef void (^TaPictureDidSelected)(CPTaPublishStatus *status,NSIndexPath *path, NSArray *srcView);

@interface CPTaPublishCell : UITableViewCell

@property (nonatomic,strong) CPTaPublishStatus *publishStatus;
@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,copy) TaPictureDidSelected taPictureDidSelected;

+ (NSString *)identifier;

// 返回每一行有多高
- (CGFloat)cellHeightWithTaPublishStatus:(CPTaPublishStatus *)publishStatus;

@end
