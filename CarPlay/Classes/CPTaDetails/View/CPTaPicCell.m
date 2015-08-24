//
//  CPTaPicCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaPicCell.h"
#import "UIImageView+WebCache.h"


@interface CPTaPicCell ()


@end

@implementation CPTaPicCell

+ (NSString *)identifier{
    return @"taPicCell";
}

- (void)setTaPhoto:(CPTaPhoto *)taPhoto{
    _taPhoto = taPhoto;
    
    NSURL *url = [NSURL URLWithString:taPhoto.thumbnail_pic];
    [self.pictureView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imageplace"]];
}

@end
