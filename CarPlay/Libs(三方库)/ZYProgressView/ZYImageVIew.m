//
//  ZYImageVIew.m
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYImageVIew.h"

@implementation ZYImageVIew

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.backgroundColor = [Tools getColor:@"dddddd"];
    self.contentMode = UIViewContentModeCenter;
}

- (void)zy_setImageWithUrl:(NSString *)url completed:(completion)completed
{
    self.clipsToBounds = NO;
    self.contentMode = UIStackViewAlignmentCenter;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        if (completed) {
            completed(image,error,cacheType,imageURL);
        }
    }];
    
}

@end