//
//  MJPhotoLoadingView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoLoadingView.h"
#import "MJPhotoBrowser.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPhotoProgressView.h"

@interface MJPhotoLoadingView ()
{
    UIImageView *_failureLabel;
    MJPhotoProgressView *_progressView;
}

@end

@implementation MJPhotoLoadingView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)showFailure
{
    [_progressView removeFromSuperview];
    
    if (_failureLabel == nil) {
        _failureLabel = [[UIImageView alloc] init];
        _failureLabel.image = [UIImage imageNamed:@"imageplace"];
        _failureLabel.width = ZYScreenWidth;
        _failureLabel.height = ZYScreenWidth;
        _failureLabel.y = (ZYScreenHeight - ZYScreenWidth) * 0.5;
        _failureLabel.x = 0;
        _failureLabel.backgroundColor = [UIColor clearColor];
        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_failureLabel];
}

- (void)showLoading
{
    [_failureLabel removeFromSuperview];
    
    if (_progressView == nil) {
        _progressView = [[MJPhotoProgressView alloc] init];
        _progressView.bounds = CGRectMake(0, 0, 30, 30);
        _progressView.center = self.center;
    }
    _progressView.progress = kMinProgress;
    [self addSubview:_progressView];
}

#pragma mark - customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}
@end
