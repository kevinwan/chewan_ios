//
//  CPSexView.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSexView.h"
#import "NSString+Extension.h"

@implementation CPSexView

- (void)setUp
{
    self.userInteractionEnabled = NO;
    [self setBackgroundImage:[UIImage imageNamed:@"男-1"] forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setIsMan:(BOOL)isMan
{
    _isMan = isMan;
    
    if (isMan) {
        [self setBackgroundImage:[UIImage imageNamed:@"男-1"] forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"女-1"] forState:UIControlStateNormal];
    }
}

@end
