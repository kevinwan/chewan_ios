//
//  CPPartnerMemberCell.m
//  CarPlay
//
//  Created by chewan on 10/20/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPPartnerMemberCell.h"

@implementation CPPartnerMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.iconView = [UIImageView new];
        [self setCornerRadius:15];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

@end
