//
//  CPSelectButton.m
//  CarPlay
//
//  Created by chewan on 10/12/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPSelectButton.h"

@implementation CPSelectButton

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
    [self setCornerRadius:11];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        
        [self setBackgroundColor:[Tools getColor:@"74ced6"]];
    }else{
        
        [self setBackgroundColor:[Tools getColor:@"dddddd"]];
    }
}

@end
