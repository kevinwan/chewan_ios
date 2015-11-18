//
//  UIImageView+ZYWebCache.h
//  CarPlay
//
//  Created by chewan on 10/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//  af的网络图片加载框架

#import <UIKit/UIKit.h>

@interface UIImageView (ZYWebCache)

- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *image))completion;

- (void)zySetReloadImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *))completion;

- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

@end
