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
    [self setBackgroundImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
        [self setBackgroundImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }
}

- (void)setAge:(NSUInteger)age
{
    _age = age;
    [self setTitle:[NSString stringWithFormat:@"%zd",age] forState:UIControlStateNormal];
}

- (void)setGender:(NSString *)gender
{
    _gender = [gender copy];
    if ([gender isEqualToString:@"男"]) {
        self.isMan = YES;
    }else{
        self.isMan = NO;
    }
}

@end
