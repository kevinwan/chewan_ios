//
//  UIImageView+ZYWebCache.m
//  CarPlay
//
//  Created by chewan on 10/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "UIImageView+ZYWebCache.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation UIImageView (ZYWebCache)

- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self zySetImageWithUrl:url placeholderImage:placeholderImage completion:nil];
}

- (void)zySetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completion:(void (^)(UIImage *))completion
{
     [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
         if(completion){
             completion(image);
         }
     } failure:nil];
}

@end
