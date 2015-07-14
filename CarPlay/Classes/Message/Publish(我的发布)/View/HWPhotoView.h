//
//  HWPhotoView.h
//  3期微博
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWPicUrl;

@interface HWPhotoView : UIImageView
/**
 *  图片模型
 */
@property (nonatomic, strong) HWPicUrl *picUrl;
@end
