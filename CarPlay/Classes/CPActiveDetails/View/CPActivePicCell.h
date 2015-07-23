//
//  CPActivePicCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPActivePhoto;

@interface CPActivePicCell : UICollectionViewCell

@property (nonatomic,strong) CPActivePhoto *activePhoto;

// 获取当前cell重用标示符
+ (NSString *)identifier;

@end
