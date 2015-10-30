//
//  UIButton+ZYWebCache.h
//  CarPlay
//
//  Created by chewan on 10/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZYWebCache)
/**
 *  完成回调方法
 *
 *  @param url              url description
 *  @param placeholderImage placeholderImage description
 *  @param completion       completion description
 *  @param state            state description
 */
- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *image))completion forState:(UIControlState)state;

/**
 *  没有完成回调方法
 *
 *  @param url              url description
 *  @param placeholderImage placeholderImage description
 *  @param state            state description
 */
- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;

@end
