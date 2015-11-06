//
//  CPBRPGMatchingSelectButton.m
//  CarPlay
//
//  Created by 公平价 on 15/11/6.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPBRPGMatchingSelectButton.h"

@implementation CPBRPGMatchingSelectButton
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self setImage:[UIImage imageNamed:@"点击效果"] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:@"初始效果"] forState:UIControlStateNormal];
    }
}
@end
