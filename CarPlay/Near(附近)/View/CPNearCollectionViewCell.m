//
//  CPNearCollectionViewCell.m
//  CarPlay
//
//  Created by chewan on 10/16/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPNearCollectionViewCell.h"
#import "CPBaseViewCell.h"

@interface CPNearCollectionViewCell ()
@property (nonatomic, weak) CPBaseViewCell *contentV;
@end

@implementation CPNearCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CPBaseViewCell *contentV = [[NSBundle mainBundle] loadNibNamed:@"CPBaseViewCell" owner:nil options:nil].lastObject;
        [self.contentView addSubview:contentV];
        [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        self.contentV = contentV;
    }
    return self;
}

- (void)setModel:(CPActivityModel *)model
{
    _model = model;
    self.contentV.model = model;
}

@end
