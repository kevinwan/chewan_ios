//
//  CPActivityDetailMiddleView.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailMiddleView.h"

@interface CPActivityDetailMiddleView()

@end

@implementation CPActivityDetailMiddleView

+ (instancetype)activityDetailMiddleView
{
    return [[NSBundle mainBundle] loadNibNamed:@"CPActivityDetailMiddleView" owner:nil options:nil].lastObject;
}

- (IBAction)loadMore:(UIButton *)sender {
    [self superViewWillRecive:CPActivityDetailLoadMoreKey info:nil];
}

- (IBAction)openActivityPath:(UIButton *)sender {
    [self superViewWillRecive:CPActivityDetailOpenPathKey info:nil];
}
@end
