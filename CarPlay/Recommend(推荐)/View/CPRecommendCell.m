//
//  CPRecommendCell.m
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPRecommendCell.h"

@interface CPRecommendCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentTextL;
@property (weak, nonatomic) IBOutlet UIImageView *bgTip;
@property (nonatomic, strong) UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *blackView;
@property (nonatomic, strong) UIButton *addressView;
@end

@implementation CPRecommendCell

- (void)awakeFromNib{
    
    [self setCornerRadius:5];
    
    self.contentTextL.preferredMaxLayoutWidth = ZYScreenWidth - 56;

    [self.bgTip addSubview:self.tipLabel];
    self.tipLabel.text = @"官方补贴50元每人";

    [self.bgImageView addSubview:self.blackView];
    [self.blackView addSubview:self.addressView];
    [self beginLayout];
    
}

- (void)beginLayout
{
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero]);
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@62);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.right.equalTo(@-5);
        make.width.equalTo(self.blackView).multipliedBy(0.4);
    }];
}

#pragma mark - 懒加载

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = ZYFont12;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIImageView *)blackView
{
    if (_blackView == nil) {
        _blackView = [[UIImageView alloc] init];
        _blackView.image = [UIImage imageNamed:@"bg_pic_b"];
        _blackView.userInteractionEnabled = YES;
    }
    return _blackView;
}

- (UIButton *)addressView
{
    if (_addressView == nil) {
        _addressView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressView setImage:[UIImage imageNamed:@"距离"] forState:UIControlStateNormal];
        _addressView.titleLabel.font = ZYFont10;
        [_addressView setTitleColor:[Tools getColor:@"8dd685"] forState:UIControlStateNormal];
        [_addressView setTitle:@"国家体育馆" forState:UIControlStateNormal];
        _addressView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
        _addressView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [[_addressView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self superViewWillRecive:RecommentAddressClickKey info:nil];
        }];
    }
    return _addressView;
}

@end
