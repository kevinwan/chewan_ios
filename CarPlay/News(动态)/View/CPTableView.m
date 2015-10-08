//
//  CPTableView.m
//  CarPlay
//
//  Created by chewan on 9/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPTableView.h"

@implementation CPTableView

- (void)setContentSize:(CGSize)contentSize
{
    CGSize newS = contentSize;
    newS.height += 35;
    [super setContentSize:newS];
}

@end
