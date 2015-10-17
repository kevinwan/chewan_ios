//
//  CPExerciseMatchingSelectButton.m
//  CarPlay
//
//  Created by 公平价 on 15/10/17.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPExerciseMatchingSelectButton.h"

@implementation CPExerciseMatchingSelectButton

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
        [self setBackgroundImage:[UIImage imageNamed:@"运动已选"] forState:UIControlStateNormal];
    }else{
        
        [self setBackgroundImage:[UIImage imageNamed:@"运动未选"] forState:UIControlStateNormal];
    }
}

@end
