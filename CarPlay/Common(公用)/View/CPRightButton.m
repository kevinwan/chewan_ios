//
//  CPRightButton.m
//  CarPlay
//
//  Created by chewan on 15/11/6.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPRightButton.h"

@implementation CPRightButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = [self.currentTitle sizeWithFont:ZYFont10].width;
    CGFloat x = contentRect.size.width - titleW - 18;
    CGFloat y = 0.5 * (contentRect.size.height - 14);
    return CGRectMake(x, y, 10, 14);
}

@end
