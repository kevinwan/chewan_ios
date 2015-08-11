//
//  CPCancleSubBtn.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPCancleSubBtn.h"

@implementation CPCancleSubBtn

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
    self.layer.cornerRadius = 12;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.clipsToBounds = YES;
    self.selected = NO;
    
    [self setTitle:@"取消成功" forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [self setTitle:@"取消关注" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [Tools getColor:@"f1f1f1"];
    }else{
        self.backgroundColor = [Tools getColor:@"fc6e51"];
    }
    [super setSelected:selected];
}
@end
