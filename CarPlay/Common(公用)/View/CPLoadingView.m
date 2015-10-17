//
//  CPLoadingView.m
//  CarPlay
//
//  Created by chewan on 10/16/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPLoadingView.h"
#import "ZYRefreshView.h"
@interface CPLoadingView()
@property (nonatomic, strong) UIView *refreshView;
@end

@implementation CPLoadingView
ZYSingleTonM
- (void)showLoadingView
{
    self.refreshView.hidden = NO;
}

- (void)dismissLoadingView
{
    self.refreshView.hidden = YES;
}

- (UIView *)refreshView
{
    if (_refreshView == nil) {
        _refreshView = [[UIView alloc] init];
        _refreshView.backgroundColor = [Tools getColor:@"efefef"];
        _refreshView.y = 64;
        _refreshView.x = 0;
        _refreshView.width = ZYScreenWidth;
        _refreshView.height = ZYScreenHeight - 64 - 68;
        [ZYKeyWindow addSubview:_refreshView];
        ZYRefreshView *rs = [[ZYRefreshView alloc] init];
        rs.center = _refreshView.centerInSelf;
        [_refreshView addSubview:rs];
    }
    return _refreshView;
}


@end
