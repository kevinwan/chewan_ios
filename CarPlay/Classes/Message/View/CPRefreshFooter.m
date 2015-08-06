//
//  CPRefreshFooter.m
//  CarPlay
//
//  Created by chewan on 15/8/4.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPRefreshFooter.h"

@implementation CPRefreshFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.stateLabel.font = [UIFont systemFontOfSize:14];
        self.autoChangeAlpha = YES;
        self.stateLabel.textColor = [Tools getColor:@"aab2bd"];
        [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];
    }
    return self;
}
@end
