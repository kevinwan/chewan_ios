//
//  CPRecommendCell.m
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPRecommendCell.h"
#import "ZYImageVIew.h"

@interface CPRecommendCell ()
@property (strong, nonatomic) UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentTextL;
@property (strong, nonatomic) UIImageView *bgTip;
@property (nonatomic, strong) UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet ZYImageVIew *bgImageView;

@property (nonatomic, strong) UIImageView *blackView;
@property (nonatomic, strong) UIButton *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHCons;

@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UIButton *female;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *male;

@property (weak, nonatomic) IBOutlet UILabel *maleLabel;


@end

@implementation CPRecommendCell

#pragma mark - 设置数据
- (void)setModel:(CPRecommendModel *)model
{
    _model = model;
    
    [self.iconView zySetImageWithUrl:model.organizer.avatar placeholderImage:CPPlaceHolderImage forState:UIControlStateNormal];
    
    self.titleLabel.text = model.organizer.nickname;
    self.contentTextL.attributedText = model.titleAttrText;
    
    if (model.subsidyPrice){
        
        self.tipLabel.text = [NSString stringWithFormat:@"官方补贴%.0f元/人",model.subsidyPrice];
    }else{
        
        self.tipLabel.text = @"官方暂无补贴";
    }

    if (model.limitType == 0) {
        
        self.partLabel.hidden = NO;
        self.male.hidden = YES;
        self.maleLabel.hidden = YES;
        self.female.hidden = YES;
        self.femaleLabel.hidden = YES;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd / ",model.nowJoinNum]];
        NSAttributedString *noLimitStr = [[NSAttributedString alloc] initWithString:@"不限" attributes:@{NSForegroundColorAttributeName : GreenColor}];
        [str appendAttributedString:noLimitStr];
        self.partLabel.attributedText = str;
    }else if (model.limitType == 1){
        
        self.partLabel.hidden = NO;
        self.male.hidden = YES;
        self.maleLabel.hidden = YES;
        self.female.hidden = YES;
        self.femaleLabel.hidden = YES;
        self.partLabel.attributedText = model.joinPersonText;
    }else if (model.limitType == 2){
        
        self.partLabel.hidden = YES;
        self.male.hidden = NO;
        self.maleLabel.hidden = NO;
        self.female.hidden = NO;
        self.femaleLabel.hidden = NO;
        
        self.maleLabel.text = [NSString stringWithFormat:@"%zd / %zd",model.maleNum,model.maleLimit];
           self.femaleLabel.text = [NSString stringWithFormat:@"%zd / %zd",model.femaleNum,model.femaleLimit];
    }
    [self.bgImageView zy_setImageWithUrl:model.covers.firstObject];
    self.priceLabel.attributedText = model.priceText;
    [self.addressView setTitle:model.destination[@"detail"] forState:UIControlStateNormal];
}

#pragma mark - 加载视图
- (void)awakeFromNib{
    
    [self setCornerRadius:5];
    
    self.contentTextL.preferredMaxLayoutWidth = ZYScreenWidth - 56;

    [self.iconView setCornerRadius:15];
    [self.bgTip addSubview:self.tipLabel];

    [self.bgImageView addSubview:self.blackView];
    [self.blackView addSubview:self.addressView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.bgTip];
    [self beginLayout];
    
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    
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
    if (iPhone4) {
        self.imageHCons.constant = 250;
        
        [self.bgTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageView.mas_top).offset(10);
            make.right.equalTo(@0);
            make.size.equalTo(CGSizeMake(111, 20));
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-10);
            make.centerY.equalTo(self.addressView);
            make.left.equalTo(@10);
        }];
        
    }else{
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentTextL.mas_bottom).offset(10);
            make.centerY.equalTo(self.bgTip);
            make.leading.equalTo(self.contentTextL);
        }];
        [self.bgTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentTextL.mas_bottom).offset(6);
            make.right.equalTo(@0);
            make.size.equalTo(CGSizeMake(111, 20));
        }];
        
        self.imageHCons.constant = ZYScreenWidth - 36;
    }
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

- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel labelWithText:@"300元 / 人" textColor:[UIColor redColor] fontSize:20];
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}

- (UIImageView *)bgTip
{
    if (_bgTip == nil) {
        _bgTip = [[UIImageView alloc] init];
        _bgTip.image = [UIImage imageNamed:@"bg_tip"];
    }
    return _bgTip;
}

@end
