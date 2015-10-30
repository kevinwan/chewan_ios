//
//  UIButton+ZYWebCache.m
//  CarPlay
//
//  Created by chewan on 10/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "UIButton+ZYWebCache.h"
#import <AFNetworking/UIButton+AFNetworking.h>
@implementation UIButton (ZYWebCache)

- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
    [self zySetImageWithUrl:url placeholderImage:placeholderImage completion:nil forState:state];
}

- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *))completion forState:(UIControlState)state
{
    ZYWeakSelf
    [self setImageForState:state withURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        ZYStrongSelf
        if (completion) {
            completion(image);
        }else{
            [self setImage:image forState:UIControlStateNormal];
        }
    } failure:nil];
}

@end
