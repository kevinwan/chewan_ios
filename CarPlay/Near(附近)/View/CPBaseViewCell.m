//
//  CPNearViewCell.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPBaseViewCell.h"
#import "FXBlurView.h"
#import "UIImage+Blur.h"
#import "MultiplePulsingHaloLayer.h"

@interface CPBaseViewCell ()
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

/**
 *  约她
 */
@property (nonatomic, strong) UIButton *dateButton;

/**
 *  应邀
 */
@property (nonatomic, strong) UIButton *invitedButton;

/**
 *  忽略
 */
@property (nonatomic, strong) UIButton *ignoreButton;

/**
 *  约她的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *dateAnim;

@end

@implementation CPBaseViewCell

// 使cell位置下移20
- (void)setFrame:(CGRect)frame
{
    CGRect newF = frame;
    newF.origin.y += 20;
    [super setFrame:newF];
}

- (void)awakeFromNib
{
    // 进行初始化设置
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    self.distanceView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);

    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:@"http://m3.biz.itc.cn/pic/new/n/50/72/Img7927250_n.jpg"] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.userIconView.image = [image blurredImageWithRadius:20];
    }];
    [self.userIconView addSubview:self.dateButton];
    [self.userIconView addSubview:self.invitedButton];
    [self.userIconView addSubview:self.ignoreButton];
    
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.userIconView);
        make.size.equalTo(CGSizeMake(56, 56));
        make.bottom.equalTo(@-10);
    }];
    
    [self.invitedButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(56, 56));
        make.bottom.equalTo(@-10);
        make.centerX.equalTo(self.userIconView).with.offset(@-38);
    }];
    
    [self.ignoreButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(self.invitedButton);
        make.centerY.equalTo(self.invitedButton);
        make.centerX.equalTo(self.userIconView).with.offset(@38);
    }];
    [self dateAnim];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    CPBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPBaseViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
 
}

#pragma mark - 处理cell事件

/**
 *  点击距离按钮
 */
- (IBAction)distanceClick:(id)sender {
    
}


#pragma mark - lazy

- (FXBlurView *)userCoverView
{
    if (_userCoverView == nil) {
        _userCoverView = [[FXBlurView alloc] init];
        _userCoverView.tintColor = [UIColor clearColor];
        [_userCoverView setBlurEnabled:YES];
        _userCoverView.blurRadius = 5;
    }
    return _userCoverView;
}

- (UIButton *)invitedButton
{
    if (_invitedButton == nil) {
        _invitedButton = [UIButton buttonWithTitle:@"应邀" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        
        _invitedButton.backgroundColor = RedColor;
        
        _invitedButton.layer.cornerRadius = 28;
        _invitedButton.clipsToBounds = YES;
        _invitedButton.hidden = YES;
    }
    return _invitedButton;
}

- (UIButton *)dateButton
{
    if (_dateButton == nil) {
        _dateButton = [UIButton buttonWithTitle:@"约她" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        
        _dateButton.backgroundColor = RedColor;
        
        _dateButton.layer.cornerRadius = 28;
        _dateButton.clipsToBounds = YES;
    }
    return _dateButton;
}

- (UIButton *)ignoreButton
{
    if (_ignoreButton == nil) {
        _ignoreButton = [UIButton buttonWithTitle:@"忽略" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        _ignoreButton.backgroundColor = RedColor;
        _ignoreButton.layer.cornerRadius = 28;
        _ignoreButton.clipsToBounds = YES;
        _ignoreButton.hidden = YES;
    }
    return _ignoreButton;
}

- (MultiplePulsingHaloLayer *)dateAnim
{
    if (_dateAnim == nil) {
        
        _dateAnim = [self multiLayer];
        
        CGFloat x = (ZYScreenWidth - 20) * 0.5;
        CGFloat y = (ZYScreenWidth - 20) / 6.0 * 5.0 - 38;
        _dateAnim.position = CGPointMake(x, y);
        [self.userIconView.layer insertSublayer:_dateAnim below:_dateButton.layer];
    }
    return _dateAnim;
}

- (MultiplePulsingHaloLayer *)multiLayer
{
    MultiplePulsingHaloLayer *multiLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:0.8];
    multiLayer.fromValueForRadius = 0.5;
    multiLayer.radius = 40;
    multiLayer.useTimingFunction = NO;
    multiLayer.fromValueForAlpha = 0.5;
    [multiLayer buildSublayers];
    [multiLayer setHaloLayerColor:RedColor.CGColor];
    return multiLayer;
}

@end
