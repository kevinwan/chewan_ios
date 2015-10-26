//
//  CPActivityDateViewCell.m
//  CarPlay
//
//  Created by chewan on 10/24/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDateViewCell.h"

@implementation CPActivityDateViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CPRecommendCell *contentV = [[NSBundle mainBundle] loadNibNamed:@"CPRecommendCell" owner:nil options:nil].lastObject;
        [self.contentView addSubview:contentV];
        [contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        self.contentV = contentV;
    }
    return self;
}

@end
