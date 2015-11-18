//
//  ZYImageVIew.h
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//  一个可以设置模糊图片的imageView

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
//  定义回调block
typedef void(^completion)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);

@interface ZYImageVIew : UIImageView
- (void)zy_setImageWithUrl:(NSString *)url;
- (void)zy_setBlurImageWithUrl:(NSString *)url;

@property (nonatomic, strong) UIImageView *placeHloderImageView;

@end
