//
//  CPActivityPartnerCell.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityPartnerCell.h"

@interface CPActivityPartnerCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) UIButton *msgButton;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIScrollView *partnersView;
@end

@implementation CPActivityPartnerCell

- (void)awakeFromNib {
    [self.inviteBtn setCornerRadius:15];
    [self.contentView addSubview:self.msgButton];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.partnersView];
    [self beginLayout];
}

- (void)beginLayout
{
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.inviteBtn);
    }];
    
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.centerY.equalTo(self.inviteBtn);
    }];
    
    [self.partnersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.agreeLabel.mas_right).offset(3);
        make.bottom.equalTo(0);
    }];
}

- (UIButton *)msgButton
{
    if (_msgButton == nil) {
        _msgButton = [[UIButton alloc] init];
    }
    return _msgButton;
}

- (UIButton *)phoneBtn
{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] init];
    }
    return _phoneBtn;
}

- (UIScrollView *)partnersView
{
    if (_partnersView == nil) {
        _partnersView = [[UIScrollView alloc] init];
        _partnersView.showsVerticalScrollIndicator = NO;
        _partnersView.showsHorizontalScrollIndicator = NO;
        _partnersView.backgroundColor = [UIColor redColor];
    }
    return _partnersView;
}

@end
