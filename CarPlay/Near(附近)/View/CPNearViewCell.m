//
//  CPNearViewCell.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewCell.h"
#import "FXBlurView.h"

@interface CPNearViewCell ()
/**
 *  背景的View
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;
/**
 *  标题label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  用户是否认证
 */
@property (weak, nonatomic) IBOutlet UIButton *authView;
/**
 *  显示车标的View
 */
@property (weak, nonatomic) IBOutlet UIButton *carView;
/**
 *  包接送
 */
@property (weak, nonatomic) IBOutlet UILabel *sendView;
/**
 *  显示性别和年龄的View
 */
@property (weak, nonatomic) IBOutlet UIButton *sexView;
/**
 *  请客的View
 */
@property (weak, nonatomic) IBOutlet UILabel *payView;
/**
 *  显示用户大图的View
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;

/**
 *  用户图像的模糊效果View
 */
@property (nonatomic, strong) FXBlurView *userCoverView;

/**
 *  显示地点的View
 */
@property (weak, nonatomic) IBOutlet UIButton *addressView;
/**
 *  显示距离的view
 */
@property (weak, nonatomic) IBOutlet UIButton *distanceView;

@end

@implementation CPNearViewCell

// 使cell位置下移20
- (void)setFrame:(CGRect)frame
{
    CGRect newF = frame;
    newF.origin.y += 20;
    [super setFrame:newF];
}

- (void)awakeFromNib
{
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    [self.userIconView addSubview:self.userCoverView];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    CPNearViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPNearViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (IBAction)he:(id)sender {
    [self.nextResponder superViewWillRecive:@"来不来" info:@"he"];
}

#pragma mark - lazy

- (FXBlurView *)userCoverView
{
    if (_userCoverView == nil) {
        _userCoverView = [[FXBlurView alloc] init];
        _userCoverView.tintColor = [UIColor clearColor];
        [_userCoverView setBlurEnabled:YES];
        _userCoverView.blurRadius = 10;
    }
    return _userCoverView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.userCoverView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

@end
