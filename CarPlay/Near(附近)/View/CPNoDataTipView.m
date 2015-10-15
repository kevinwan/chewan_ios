//
//  CPNoDataTipView.m
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPNoDataTipView.h"


@implementation CPNoDataTipView

+ (instancetype)noDataTipView
{
    return [[NSBundle mainBundle] loadNibNamed:@"CPNoDataTipView" owner:nil options:nil].lastObject;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

@end
