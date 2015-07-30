//
//  CPTaPicCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTaPhoto.h"

@interface CPTaPicCell : UICollectionViewCell

// 接受图片
@property (nonatomic,strong) CPTaPhoto *taPhoto;

+ (NSString *)identifier;

@end
