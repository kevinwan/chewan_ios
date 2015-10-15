//
//  CPMyBaseCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyBaseCell.h"

@implementation CPMyBaseCell

- (void)awakeFromNib {
    if (!_icon) {
        _titleLable.x=_icon.x;
        [_icon removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
