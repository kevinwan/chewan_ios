//
//  CPTaIconCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTaMember.h"

@interface CPTaIconCell : UICollectionViewCell

@property (nonatomic,strong) CPTaMember *taMember;

// 获取当前cell重用标示符
+ (NSString *)identifier;

@end
