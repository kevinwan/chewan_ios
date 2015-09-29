//
//  CPNoHighLightButton.m
//  CarPlay
//
//  Created by chewan on 9/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPNoHighLightButton.h"

@implementation CPNoHighLightButton

- (void)awakeFromNib
{
      [self setUp];
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
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
