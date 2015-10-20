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

@interface CPActivityPartnerCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) UIButton *msgButton;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UICollectionView *partnersView;
@end

static NSString *ID = @"memberIconCell";
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
        make.left.equalTo(self.agreeLabel.mas_right).offset(3);
        make.bottom.equalTo(0);
    }];
}

- (IBAction)comeOnBaby:(UIButton *)sender {
    
    [CPComeOnTipView showWithActivityId:nil targetUserId:nil];
    
}


- (void)setModel:(CPRecommendModel *)model
{
    _model = model;
    
    
    [self.partnersView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPPartnerMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.iconView.image = [UIImage imageNamed:@"ceo头像"];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - lazy
- (UIButton *)msgButton
{
    if (_msgButton == nil) {
        _msgButton = [[UIButton alloc] init];
        [_msgButton setImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
        _msgButton.hidden = YES;
    }
    return _msgButton;
}

- (UIButton *)phoneBtn
{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] init];
        
        [_phoneBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
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

@end
