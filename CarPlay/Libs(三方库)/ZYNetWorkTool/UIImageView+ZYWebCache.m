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
    [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:placeholderImage success:nil failure:nil];
}
@end
