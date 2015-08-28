//
//  CPHomeIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeIconCell.h"
#import "CPHomeMember.h"
#import "UIImageView+WebCache.h"

@interface CPHomeIconCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic,strong) UIButton *countBtn;
@end

@implementation CPHomeIconCell
// 获取当前cell重用标示符
+ (NSString *)identifier{
    return @"homeMemCell";
}

- (UIButton *)countBtn{
    if (!_countBtn) {
        _countBtn = [[UIButton alloc] init];
        _countBtn.frame = CGRectMake(0, 0, 25, 25);
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _countBtn;
}

- (void)setHomeMember:(CPHomeMember *)homeMember{
    _homeMember = homeMember;
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    // 添加按钮后取出头像图片
    if ([homeMember.photo isEqualToString:@"用户小头像底片"]) {
        self.countBtn.hidden = NO;
        self.iconView.image = [UIImage imageNamed:homeMember.photo];
        NSString *iconCount = [NSString stringWithFormat:@"%@",@(homeMember.membersCount)];
        [self.countBtn setTitle:iconCount forState:UIControlStateNormal];
        [self.iconView addSubview:self.countBtn];
    }else{
        
        NSURL *url = [NSURL URLWithString:_homeMember.photo];
        [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
        //        [self.countBtn removeFromSuperview];
        self.countBtn.hidden = YES;
    }
    
    
}

@end
