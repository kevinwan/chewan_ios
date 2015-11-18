//
//  CPLoadingButton.m
//  CarPlay
//
//  Created by chewan on 10/27/15.
//  Copyright © 2015 chewan. All rights reserved.
// 

#import "CPLoadingButton.h"

@interface CPLoadingButton ()
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@end

@implementation CPLoadingButton

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
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] init];
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    loadingView.hidesWhenStopped = YES;
    [self addSubview:loadingView];
    self.loadingView = loadingView;
}

- (void)startLoading
{
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.loadingView startAnimating];
}

- (void)stopLoading
{
    [self setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    [self.loadingView stopAnimating];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.loadingView.center = self.centerInSelf;
}

@end
