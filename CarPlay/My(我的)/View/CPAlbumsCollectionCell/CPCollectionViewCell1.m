//
//  CPCollectionViewCell.m
//  CarPlay
//
//  Created by 公平价 on 15/10/22.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCollectionViewCell1.h"

@implementation CPCollectionViewCell1

- (void)awakeFromNib {
    [self.imageView.layer setMasksToBounds:YES];
    [self.imageView.layer setCornerRadius:3.0f];
}

@end
