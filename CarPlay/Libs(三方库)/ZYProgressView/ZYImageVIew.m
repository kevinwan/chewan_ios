//
//  ZYImageVIew.m
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYImageVIew.h"

@interface ZYImageVIew ()

@end

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

- (void)setImage:(UIImage *)image
{
    self.placeHloderImageView.hidden = YES;
    [super setImage:image];
    if (image && self.showImage ) {
        [self insertSubview:self.userCoverView atIndex:0];
    }
}
- (void)zy_setImageWithUrl:(NSString *)url completed:(completion)completed
{
    self.placeHloderImageView.hidden = NO;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completed) {
            completed(image,error,cacheType,imageURL);
        }
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
    self.userCoverView.frame = self.bounds;
}

- (FXBlurView *)userCoverView
{
    if (_userCoverView == nil) {
        _userCoverView = [[FXBlurView alloc] initWithFrame:self.bounds];
        _userCoverView.tintColor = [UIColor clearColor];
        [_userCoverView setBlurEnabled:YES];
        _userCoverView.blurRadius = 5;
        [_userCoverView setDynamic:NO];
    }
    return _userCoverView;
}
@end