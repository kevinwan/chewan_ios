//
//  HWPhotosView.h
//  3期微博
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWStatusFrame;

@interface HWPhotosView : UIView

/**
 *  所有需要展示的配图
 */
@property (nonatomic, strong) NSArray *pic_urls;

/**
 *  根据配图的个数计算配图容器的宽高
 *
 *  @param count 配图的个数
 *
 *  @return 配图容器的宽高
 */
+ (CGSize)sizeWithPhotoCount:(NSUInteger)count;
@end
