//
//  HMPhoto.m
//
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 fengxing. All rights reserved.
//

#import "HMPhoto.h"

@implementation HMPhoto

- (void)setThumbnail_pic:(NSString *)thumbnail_pic
{
    _thumbnail_pic = [thumbnail_pic copy];
}

- (void)setOriginal_pic:(NSString *)original_pic
{
    _original_pic = [original_pic copy];
    _bmiddle_pic = original_pic;
}

@end
