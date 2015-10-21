//
//  CPOtherMatchingSelectView.m
//  CarPlay
//
//  Created by 公平价 on 15/10/21.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPOtherMatchingSelectView.h"

@implementation CPOtherMatchingSelectView
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
        [self setBackgroundImage:[UIImage imageNamed:@"吃饭已选"] forState:UIControlStateNormal];
    }else{
        
        [self setBackgroundImage:[UIImage imageNamed:@"吃饭未选"] forState:UIControlStateNormal];
    }
}
@end
