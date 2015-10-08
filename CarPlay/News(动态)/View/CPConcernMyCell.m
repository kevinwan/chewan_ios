//
//  CPConcernMyCell.m
//  CarPlay
//
//  Created by chewan on 9/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPConcernMyCell.h"

@implementation CPConcernMyCell

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.y += 35;
    [super setFrame:rect];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
