//
//  CPActiveIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/23.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActiveIconCell.h"
#import "UIImageView+WebCache.h"
#import "CPActiveMember.h"

@interface CPActiveIconCell()
@property (nonatomic,strong) UIImageView *iconView;
@end

@implementation CPActiveIconCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置图片frame
        self.iconView.frame = CGRectMake(0, 0, 25, 25);
        [self addSubview:_iconView];
    }
    return self;
}

// imageview懒加载
- (UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

+ (NSString *)identifier{
    return @"activeIconCell";
}

- (void)setActiveMember:(CPActiveMember *)activeMember{
    _activeMember = activeMember;
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:_activeMember.photo];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    
    // 判断如果头像超过4个，第五个头像就显示数字
    if (_activeMember.membersCount > 5 && _activeMember.currentMember == 5) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.backgroundColor = [UIColor grayColor];
        NSString *iconCount = [NSString stringWithFormat:@"%@",@(_activeMember.membersCount)];
        [btn setTitle:iconCount forState:UIControlStateNormal];
        [self.iconView addSubview:btn];
        
        // 添加按钮后取出头像图片
        self.iconView.image = [UIImage imageNamed:@""];
    }
    
    
}


@end
