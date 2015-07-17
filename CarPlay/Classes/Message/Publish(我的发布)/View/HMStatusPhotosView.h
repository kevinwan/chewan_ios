//
//  HMStatusPhotosView.h
//
//
//  Created by apple on 14-7-15.
//  Copyright (c) 2014年 fengxing. All rights reserved.
//  微博cell里面的相册 -- 里面包含N个HMStatusPhotoView

#import <UIKit/UIKit.h>

@interface HMStatusPhotosView : UIView
/**
 *  图片数据（里面都是HMPhoto模型）
 */
@property (nonatomic, strong) NSArray *pic_urls;

/**
 *  根据图片个数计算相册的最终尺寸
 */
+ (CGSize)sizeWithPhotosCount:(NSUInteger)photosCount;

@end
