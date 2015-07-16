//
//  CPHomeStatusCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeStatus;

@interface CPHomeStatusCell : UITableViewCell

@property (nonatomic,strong) CPHomeStatus *status;

+ (NSString *)identifier;

// 返回每一行有多高
- (CGFloat)cellHeightWithStatus:(CPHomeStatus *)status;

@end
