//
//  CPPayButton.m
//  CarPlay
//
//  Created by chewan on 15/7/15.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPPayButton.h"

@implementation CPPayButton

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
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setPayOption:(NSString *)payOption
{
    _payOption = [payOption copy];
    
    if ([payOption isEqualToString:@"请客"]) {
        [self payWithSelf];
    }else if ([payOption isEqualToString:@"AA制"]){
        [self payWithAA];
    }else{
        [self payWithOther];
    }
}

- (void)payWithSelf
{
    [self setTitle:@"我请客" forState:UIControlStateNormal];
    [self setBackgroundColor:[Tools getColor:@"fc6e51"]];
}

- (void)payWithAA
{
    [self setTitle:@"AA制" forState:UIControlStateNormal];
    [self setBackgroundColor:[Tools getColor:@"41d8d5"]];
}

- (void)payWithOther
{
    [self setTitle:@"请我吧" forState:UIControlStateNormal];
    [self setBackgroundColor:[Tools getColor:@"ccd1d9"]];
}

@end
