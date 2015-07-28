//
//  CPEditHeadIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditHeadIconCell.h"

@implementation CPEditHeadIconCell

- (void)awakeFromNib {
    self.headIcon.layer.cornerRadius=17.5;
    self.headIcon.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
