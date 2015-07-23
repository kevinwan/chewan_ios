//
//  CPActiveIconCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/23.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPActiveMember;

@interface CPActiveIconCell : UICollectionViewCell

@property (nonatomic,strong) CPActiveMember *activeMember;

// 获取当前cell重用标示符
+ (NSString *)identifier;

@end
