//
//  CPActivityPartnerCell.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityPartnerCell.h"
#import "CPPartnerMemberCell.h"
#import "CPSexView.h"

@interface CPActivityPartnerCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) UIImageView *iconAuthView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet CPSexView *sexView;

@property (weak, nonatomic) IBOutlet UIButton *carView;

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

#pragma mark - 布局
- (void)awakeFromNib {
    [self.inviteBtn setCornerRadius:15];
    [self.iconView setCornerRadius:25];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    ZYWeakSelf
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        ZYStrongSelf
        if ([_model.userId isDiffToString:CPUserId]) {
            [self superViewWillRecive:CPClickUserIcon info:_model.userId];
        }
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
        make.left.equalTo(self.agreeLabel.mas_right).offset(12);
        make.centerY.equalTo(self.agreeLabel);
        make.height.equalTo(@38);
    }];
    
    [self.iconAuthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView).offset(32);
        make.left.equalTo(self.iconView).offset(35);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
}
#pragma mark - 事件交互
- (IBAction)comeOnBaby:(UIButton *)sender {
    //inviteStatus        当前登录用户 邀请 该用户的 状态；
    //0 没有邀请过           1 邀请中
    //2 邀请同意             3 邀请被拒绝
    
    
    //beInvitedStatus      该用户是否邀请过 登录用户
    //0 没有邀请过           1 邀请中
    //2 邀请同意             3 邀请被拒绝
    if (_model.beInvitedStatus == 1) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@已经邀请了您,快去动态中查看吧",self.model.nickname]];
        return;
    }
    
    if ([sender.currentTitle isEqualToString:@"邀请同去"]) {
        [self superViewWillRecive:CPComeOnBabyClickKey info:_model];
    }
    
}

#pragma mark - 模型赋值
- (void)setModel:(CPPartMember *)model
{
    _model = model;

    
    [self.iconView zySetImageWithUrl:model.avatar placeholderImage:CPPlaceHolderImage];
    
    self.partNumLabel.attributedText = model.invitedCountStr;
    
    self.nicknameLabel.text = model.nickname;
    
    self.distanceLabel.text = model.distanceStr.trimLength ? model.distanceStr : @"未知";
    
    self.agreeLabel.text = [NSString stringWithFormat:@"已接受 %zd",model.acceptCount];
    
    self.sexView.age = model.age;
    self.sexView.isMan = model.isMan;

    if ([model.photoAuthStatus isEqualToString:@"认证通过"]){
        self.iconAuthView.hidden = NO;
    }else{
        self.iconAuthView.hidden = YES;
    }
    
    if ([model.licenseAuthStatus isEqualToString:@"认证未通过"]) {
        [self.carView setImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }else{
        [self.carView zySetImageWithUrl:model.car.logo placeholderImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }
    
    //inviteStatus        当前登录用户 邀请 该用户的 状态；
    //0 没有邀请过           1 邀请中
    //2 邀请同意             3 邀请被拒绝
    
    
    //beInvitedStatus      该用户是否邀请过 登录用户
    //0 没有邀请过           1 邀请中
    //2 邀请同意             3 邀请被拒绝
    
    // 如果不是自己
    if ([model.userId isDiffToString:CPUserId]){
        // 1. 没有邀请状态,需要查看对方对我的邀请状态
        
        if (model.inviteStatus == 2 || model.beInvitedStatus == 2) {
            self.inviteBtn.hidden = YES;
            self.phoneBtn.hidden = NO;
            self.msgButton.hidden = NO;
        }else{
            
            // 如果当前用户的邀请状态为0,需判断对方对当前用户的状态
            if (model.inviteStatus == 0) {
                
                if (model.beInvitedStatus == 0) {
                    
                    self.phoneBtn.hidden = YES;
                    self.msgButton.hidden = YES;
                    self.inviteBtn.hidden = NO;
                    [self.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                    [self.inviteBtn setBackgroundColor:[Tools getColor:@"74ced6"]];
                    [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                }else if (model.beInvitedStatus == 1){
                    
                    self.phoneBtn.hidden = YES;
                    self.msgButton.hidden = YES;
                    self.inviteBtn.hidden = NO;
                    [self.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                    [self.inviteBtn setBackgroundColor:[Tools getColor:@"74ced6"]];
                    [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                }else if (model.beInvitedStatus == 2){
                    
                    self.phoneBtn.hidden = NO;
                    self.msgButton.hidden = NO;
                    self.inviteBtn.hidden = YES;
                }else if (model.beInvitedStatus == 3){
                    self.phoneBtn.hidden = YES;
                    self.msgButton.hidden = YES;
                    self.inviteBtn.hidden = NO;
                    [self.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                    [self.inviteBtn setBackgroundColor:[Tools getColor:@"74ced6"]];
                    [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
        }
            else if (model.inviteStatus == 1){
            
            self.phoneBtn.hidden = YES;
            self.msgButton.hidden = YES;
            self.inviteBtn.hidden = NO;
            [self.inviteBtn setTitle:@"邀请中" forState:UIControlStateNormal];
            [self.inviteBtn setBackgroundColor:[Tools getColor:@"74ced6"]];
            [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            else if (model.inviteStatus == 2){
            
            self.phoneBtn.hidden = NO;
            self.msgButton.hidden = NO;
            self.inviteBtn.hidden = YES;
        }
            else if (model.inviteStatus == 3){
            self.phoneBtn.hidden = YES;
            self.msgButton.hidden = YES;
            self.inviteBtn.hidden = NO;
            [self.inviteBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.inviteBtn setTitleColor:GrayColor forState:UIControlStateNormal];
            [self.inviteBtn setBackgroundColor:[UIColor clearColor]];
        }
        }
    }else{
        self.inviteBtn.hidden = YES;
        self.phoneBtn.hidden = YES;
        self.msgButton.hidden = YES;
    }
    
    [self.partnersView reloadData];
}

#pragma mark - 数据源方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPPartnerMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    CPUser *member = self.model.acceptMembers[indexPath.item];
    
    [cell.iconView zySetImageWithUrl:member.avatar placeholderImage:CPPlaceHolderImage];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.acceptMembers.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPUser *member = self.model.acceptMembers[indexPath.item];
    if ([member.userId isDiffToString:CPUserId]) {
        [self superViewWillRecive:CPClickUserIcon info:member.userId];
    }
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
