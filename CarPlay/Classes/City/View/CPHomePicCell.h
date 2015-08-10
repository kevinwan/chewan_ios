//
//  CPHomePicCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/15.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomePhoto;

@interface CPHomePicCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (nonatomic,strong) CPHomePhoto *homePhoto;

// 获取当前cell重用标示符
+ (NSString *)identifier;



@end
