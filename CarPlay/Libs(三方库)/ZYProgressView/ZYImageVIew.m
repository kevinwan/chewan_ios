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
    [self addSubview:self.placeHloderImageView];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

- (void)zy_setImageWithUrl:(NSString *)url
{
    self.placeHloderImageView.hidden = NO;
    
    [self zySetImageWithUrl:url placeholderImage:nil completion:^(UIImage *image) {
        self.image = image;
        self.placeHloderImageView.hidden = YES;
    }];
}

- (void)zy_setBlurImageWithUrl:(NSString *)url
{
    self.placeHloderImageView.hidden = NO;
    [self sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
        self.placeHloderImageView.hidden = YES;
    }];
}

- (UIImageView *)placeHloderImageView
{
    if (!_placeHloderImageView) {
        _placeHloderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    }
    return _placeHloderImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeHloderImageView.center = self.centerInSelf;
}

@end