//
//  CPMyDateCell.m
//  CarPlay
//
//  Created by chewan on 10/24/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPMyDateCell.h"

@implementation CPMyDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
