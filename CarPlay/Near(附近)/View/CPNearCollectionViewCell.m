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

        self.contentV = contentV;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setModel:(CPActivityModel *)model
{
    if (model.applicant) {
        model.organizer = model.applicant;
    }
    self.contentV.model = model;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.contentV.indexPath = indexPath;
}

@end
