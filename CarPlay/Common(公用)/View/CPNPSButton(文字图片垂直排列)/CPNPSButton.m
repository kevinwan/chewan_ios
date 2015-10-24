//
//  CPNPSButton.m
//  CarPlay
//
//  Created by 公平价 on 15/10/8.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNPSButton.h"


@implementation CPNPSButton

- (void)awakeFromNib
{
    _label = [UILabel new];
    _label.textColor = [Tools getColor:@"333333"];
    _label.font = ZYFont10;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.right.equalTo(@0);
        make.height.equalTo(@20);
    }];
}
@end
