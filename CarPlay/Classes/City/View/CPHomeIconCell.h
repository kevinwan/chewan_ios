//
//  CPHomeIconCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeMember;

@interface CPHomeIconCell : UICollectionViewCell

@property (nonatomic,strong) CPHomeMember *homeMember;

// 获取当前cell重用标示符
+ (NSString *)identifier;

@end
