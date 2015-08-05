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
        [self setTitle:@"已无更多数据" forState:MJRefreshStateNoMoreData];
    }
    return self;
}
@end
