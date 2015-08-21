//
//  CPTaIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaIconCell.h"
#import "UIImageView+WebCache.h"

@interface CPTaIconCell ()

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic,strong) UIButton *countBtn;
@end

@implementation CPTaIconCell

+ (NSString *)identifier{
    return @"taIconCell";
}


- (UIButton *)countBtn{
    if (!_countBtn) {
        _countBtn = [[UIButton alloc] init];
        _countBtn.frame = CGRectMake(0, 0, 25, 25);
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _countBtn;
}

- (void)setTaMember:(CPTaMember *)taMember{
    _taMember = taMember;
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:taMember.photo];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    
    
    // 添加按钮后取出头像图片
    if ([taMember.photo isEqualToString:@"用户小头像底片"]) {
        self.countBtn.hidden = NO;
        self.iconView.image = [UIImage imageNamed:taMember.photo];
        NSString *iconCount = [NSString stringWithFormat:@"%@",@(taMember.membersCount)];
        [self.countBtn setTitle:iconCount forState:UIControlStateNormal];
        [self.iconView addSubview:self.countBtn];
    }else{
        //        [self.countBtn removeFromSuperview];
        self.countBtn.hidden = YES;
    }
    
    
    
    
}

@end
