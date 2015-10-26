//
//  CPActivityPartnerCell.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityPartnerCell.h"
#import "CPPartnerMemberCell.h"
#import "CPComeOnTipView.h"
#import "CPSexView.h"

@interface CPActivityPartnerCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) UIImageView *iconAuthView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet CPSexView *sexView;

@property (weak, nonatomic) IBOutlet UIButton *carView;
@property (weak, nonatomic) IBOutlet UILabel *cartypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (nonatomic, strong) UIButton *msgButton;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UICollectionView *partnersView;
@end

static NSString *ID = @"memberIconCell";
@implementation CPActivityPartnerCell

- (void)awakeFromNib {
    [self.inviteBtn setCornerRadius:15];
    [self.iconView setCornerRadius:25];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [self superViewWillRecive:CPClickUserIcon info:_model.userId];
    }];
    [self.iconView addGestureRecognizer:tap];
    [self.contentView addSubview:self.msgButton];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.partnersView];
    [self.contentView addSubview:self.iconAuthView];
    [self beginLayout];
}

- (void)beginLayout
{
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.inviteBtn);
        make.size.equalTo(CGSizeMake(32.5, 30));
    }];
    
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneBtn.mas_left);
        make.centerY.equalTo(self.inviteBtn);
        make.size.equalTo(CGSizeMake(32.5, 30));
    }];
    
    [self.partnersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.agreeLabel.mas_right).offset(12);
        make.bottom.equalTo(0);
    }];
    
    [self.iconAuthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView).offset(32);
        make.left.equalTo(self.iconView).offset(35);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
}

- (IBAction)comeOnBaby:(UIButton *)sender {
    
    [CPComeOnTipView showWithActivityId:self.activityId targetUserId:_model.userId];
}

- (void)setModel:(CPPartMember *)model
{
    _model = model;
    
    if ([model.userId isEqualToString:CPUserId]) {
        self.inviteBtn.hidden = YES;
    }else{
        self.inviteBtn.hidden = NO;
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:CPPlaceHolderImage options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    self.partNumLabel.attributedText = model.invitedCountStr;
    
    self.nicknameLabel.text = model.nickname;
    
    self.distanceLabel.text = model.distanceStr;
    
    self.agreeLabel.text = [NSString stringWithFormat:@"已接受 %zd",model.acceptCount];
    
    self.sexView.age = model.age;
    self.sexView.isMan = model.isMan;
    
    if ([model.authentication isEqualToString:@"认证成功"]) {
        
        self.iconAuthView.hidden = NO;
    }else{
        
        self.iconAuthView.hidden = YES;
    }
    
    if (model.car.logo.length) {
        self.carView.hidden = NO;
        [self.carView sd_setImageWithURL:[NSURL URLWithString:model.car.logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"车主未认证"]];
        self.cartypeLabel.text = model.car.model;
    }else{
        self.cartypeLabel.hidden = YES;
        [self.carView setImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }
    
    if (model.acceptMe) {
        self.inviteBtn.hidden = YES;
        self.phoneBtn.hidden = NO;
        self.msgButton.hidden = NO;
    }else{
        if ([model.userId isEqualToString:CPUserId]) {
            self.inviteBtn.hidden = YES;
        }else{
            self.inviteBtn.hidden = NO;
        }
        self.phoneBtn.hidden = YES;
        self.msgButton.hidden = YES;
    }
    
    [self.partnersView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPPartnerMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    CPUser *member = self.model.acceptMembers[indexPath.item];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:CPPlaceHolderImage options:SDWebImageLowPriority | SDWebImageRetryFailed];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.acceptMembers.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPUser *member = self.model.acceptMembers[indexPath.item];
    [self superViewWillRecive:CPClickUserIcon info:member.userId];
}

#pragma mark - lazy
- (UIButton *)msgButton
{
    if (_msgButton == nil) {
        _msgButton = [[UIButton alloc] init];
        [_msgButton setImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
        [[_msgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self superViewWillRecive:CPOfficeActivityMsgButtonClick info:_model];
        }];
        _msgButton.hidden = YES;
    }
    return _msgButton;
}

- (UIButton *)phoneBtn
{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] init];
        
        [_phoneBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [[_phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self superViewWillRecive:CPOfficeActivityPhoneButtonClick info:_model];
        }];
        _phoneBtn.hidden = YES;
    }
    return _phoneBtn;
}

- (UIScrollView *)partnersView
{
    if (_partnersView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(30, 30);
        _partnersView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _partnersView.showsVerticalScrollIndicator = NO;
        _partnersView.showsHorizontalScrollIndicator = NO;
        _partnersView.delegate = self;
        _partnersView.dataSource = self;
        _partnersView.bounces = NO;
        _partnersView.backgroundColor = [UIColor whiteColor];
        [_partnersView registerClass:[CPPartnerMemberCell class] forCellWithReuseIdentifier:ID];
    }
    return _partnersView;
}

- (UIImageView *)iconAuthView
{
    if (_iconAuthView == nil) {
        _iconAuthView = [[UIImageView alloc] init];
        _iconAuthView.image = [UIImage imageNamed:@"头像图标"];
    }
    return _iconAuthView;
}

@end
