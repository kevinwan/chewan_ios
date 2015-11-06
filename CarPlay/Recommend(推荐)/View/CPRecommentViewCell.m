//
//  CPRecommentViewCell.m
//  CarPlay
//
//  Created by chewan on 10/16/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPRecommentViewCell.h"

@interface CPRecommentViewCell ()
@property (nonatomic, strong) CPRecommendCell *contentV;
@end

@implementation CPRecommentViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CPRecommendCell *contentV = [[NSBundle mainBundle] loadNibNamed:@"CPRecommendCell" owner:nil options:nil].lastObject;
        [self.contentView addSubview:contentV];
        [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        self.contentV = contentV;
    }
    return self;
}

- (void)setModel:(CPRecommendModel *)model
{
    _model = model;
    self.contentV.model = model;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.contentV.indexPath = indexPath;
}

@end
