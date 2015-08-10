//
//  CPRefreshHeader.m
//  CarPlay
//
//  Created by chewan on 15/8/4.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPRefreshHeader.h"

@implementation CPRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.arrowView.image = [UIImage imageNamed:@"refreshArrow"];
        self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        [self setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
        self.stateLabel.font = [UIFont systemFontOfSize:12];
        self.automaticallyChangeAlpha = YES;
        self.stateLabel.textColor = [Tools getColor:@"aab2bd"];
        self.lastUpdatedTimeLabel.textColor = [Tools getColor:@"aab2bd"];
    }
    return self;
}

@end
