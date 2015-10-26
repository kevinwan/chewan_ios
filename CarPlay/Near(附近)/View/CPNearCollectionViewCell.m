//
//  CPNearCollectionViewCell.m
//  CarPlay
//
//  Created by chewan on 10/16/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPNearCollectionViewCell.h"
#import "CPBaseViewCell.h"


@implementation CPNearCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CPBaseViewCell *contentV = [CPBaseViewCell baseCell];
        [self.contentView addSubview:contentV];

        self.contentV = contentV;
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}
@end
