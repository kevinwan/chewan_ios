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
#import "CPSexView.h"
#import "UIButton+WebCache.h"

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
 *  显示车型的View
 */
@property (weak, nonatomic) IBOutlet UILabel *carTypeView;

/**
 *  包接送
 */
@property (weak, nonatomic) IBOutlet UILabel *sendView;
/**
 *  显示性别和年龄的View
 */
@property (weak, nonatomic) IBOutlet CPSexView *sexView;
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
 *  提示未认证
 */
@property (nonatomic, strong) UIView *tipView;

/**
 *  上传按钮
 */
@property (nonatomic, strong) UIButton *uploadButton;

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
    [self.bgView setCornerRadius:5];
    self.distanceView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);

    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:@"http://m3.biz.itc.cn/pic/new/n/50/72/Img7927250_n.jpg"] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.userIconView.image = [image blurredImageWithRadius:20];
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes.rac_gestureSignal subscribeNext:^(id x) {
        
        if (![_model.organizer.photoAuthStatus isEqualToString:@"认证通过"]) {
            self.tipView.hidden = NO;
        }
    }];
    [self.userIconView addGestureRecognizer:tapGes];
    [self.userIconView addSubview:self.tipView];
    [self.userIconView addSubview:self.dateButton];
    [self.userIconView addSubview:self.invitedButton];
    [self.userIconView addSubview:self.ignoreButton];
    [self dateAnim];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    CPBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPBaseViewCell" owner:nil options:nil].lastObject;
    }
    cell.tipView.hidden = YES;
    return cell;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
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
    
    [self.tipView makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.and.top.equalTo(@0);
        make.height.equalTo(self.mas_height).multipliedBy(0.5);
    }];
 
}

/**
 *  根据model设置cell展示的数据
 *
 *  @param model model description
 */
- (void)setModel:(CPActivityModel *)model
{
    _model = model;
    
    self.sexView.isMan = model.organizer.isMan;
    self.sexView.age = model.organizer.age;
    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:model.organizer.avatar] placeholderImage:CPPlaceHolderImage options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.userIconView.image = [image blurredImageWithRadius:10];
    }];
    
    [self.distanceView setTitle:[NSString stringWithFormat:@"%zd",model.distance] forState:UIControlStateNormal];
    
    self.payView.text = model.pay;
    self.sendView.hidden = !model.transfer;
    if (model.title.length) {
        self.titleLabel.text = model.title;
    }else{
        self.titleLabel.text = @"";
    }
    
    if ([model.organizer.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.authView setImage:[UIImage imageNamed:@"头像已认证"] forState:UIControlStateNormal];
    }else{
        [self.authView setImage:[UIImage imageNamed:@"未认证-审核中"] forState:UIControlStateNormal];
    }
    
    if ([model.organizer.licenseAuthStatus isEqualToString:@"认证通过"]) {
        self.carView.hidden = NO;
        self.carTypeView.hidden = NO;
        [self.carView sd_setImageWithURL:[NSURL URLWithString:model.organizer.car.logo] forState:UIControlStateNormal placeholderImage:CPPlaceHolderImage];
        self.carTypeView.text = model.organizer.car.model;
    }else{
        self.carView.hidden = YES;
        self.carTypeView.hidden = YES;
    }
}

#pragma mark - 处理cell事件

/**
 *  点击距离按钮
 */
- (IBAction)distanceClick:(id)sender {
    
}

- (IBAction)loveClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
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
        _dateButton = [UIButton buttonWithTitle:@"邀Ta" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        
        _dateButton.backgroundColor = RedColor;
        
        _dateButton.layer.cornerRadius = 28;
        _dateButton.clipsToBounds = YES;
        [[_dateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要什么自行车" delegate:nil cancelButtonTitle:@"要" otherButtonTitles:nil, nil];
            [a.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x isEqual:@0]) {
                    DLog(@"要要切克闹");
                }
            }];
            [a show];
        }];
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
    multiLayer.fromValueForRadius = 0.6;
    multiLayer.radius = 40;
    multiLayer.useTimingFunction = NO;
    multiLayer.fromValueForAlpha = 1.0;
    [multiLayer buildSublayers];
    [multiLayer setHaloLayerColor:RedColor.CGColor];
    return multiLayer;
}

/**
 *  提示未上传图片
 */
- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = [UIColor clearColor];
        
        UILabel *textL = [UILabel new];
        textL.text = @"上传照片即可查看Ta的照片呦~";
        textL.textColor = [UIColor whiteColor];
        textL.font = ZYFont14;
        textL.textAlignment = NSTextAlignmentRight;
        [textL sizeToFit];
        [_tipView addSubview:textL];
        
        UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadBtn.titleLabel.font = ZYFont14;
        [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
        [uploadBtn setBackgroundImage:[UIImage imageNamed:@"btn_pic"] forState:UIControlStateNormal];
        
        [_tipView addSubview:uploadBtn];
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.titleLabel.font = ZYFont14;
        [cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
        [cameraBtn setBackgroundImage:[UIImage imageNamed:@"btn_pic"] forState:UIControlStateNormal];
        cameraBtn.alpha = 0;
        [_tipView addSubview:cameraBtn];
        
        [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(uploadBtn);
            make.size.equalTo(uploadBtn);
            make.top.equalTo(uploadBtn);
        }];

        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.titleLabel.font = ZYFont14;
        [photoBtn setTitle:@"照片" forState:UIControlStateNormal];
        [photoBtn setBackgroundImage:[UIImage imageNamed:@"btn_pic"] forState:UIControlStateNormal];
        [_tipView addSubview:photoBtn];
         photoBtn.alpha = 0;
        
        [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(uploadBtn);
            make.size.equalTo(uploadBtn);
            make.top.equalTo(uploadBtn);
        }];
        
        [[uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            if (cameraBtn.alpha == 0){
                
                cameraBtn.alpha = 1;
                photoBtn.alpha = 1;
                [cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(uploadBtn.mas_bottom).offset(10);
                }];
                
                [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(cameraBtn.mas_bottom).offset(10);
                }];
            }else{
                cameraBtn.alpha = 0;
                photoBtn.alpha = 0;
                [cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(uploadBtn);
                }];
                
                [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(cameraBtn);
                }];

            }
            
            [UIView animateWithDuration:0.25 animations:^{
                [_tipView layoutIfNeeded];
            }];
            
        }];
        
        
        [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@15);
            make.size.equalTo(CGSizeMake(58, 30));
        }];
        
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(uploadBtn.mas_left).with.offset(-10);
            make.center.equalTo(uploadBtn);
            make.left.equalTo(@0);
        }];
    }
    return _tipView;
}

@end
