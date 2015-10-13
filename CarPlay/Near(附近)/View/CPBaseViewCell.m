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
#import "CPNoHighLightButton.h"

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
@property (nonatomic, strong) UIImageView *tipView;

/**
 *  上传按钮
 */
@property (nonatomic, strong) UIButton *uploadButton;

/**
 *  约她的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *dateAnim;

/**
 *  应邀的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *inviAnim;

/**
 *  忽略的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *ignoreAnim;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginCons;

@end

@implementation CPBaseViewCell

// 使cell位置下移20
//- (void)setFrame:(CGRect)frame
//{
//    CGRect newF = frame;
//    newF.origin.y += 20;
//    [super setFrame:newF];
//}

- (void)awakeFromNib
{
    self.marginCons.constant = 12;
    // 进行初始化设置
    [self.bgView setCornerRadius:5];
    self.distanceView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);

    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:@"http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg"] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
    [self beginLayoutSubviews];
}

//+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
//{
//    CPBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (cell == nil) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"CPBaseViewCell" owner:nil options:nil].lastObject;
//    }
//    return cell;
//}
- (void)beginLayoutSubviews
{
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.userIconView);
        make.size.equalTo(CGSizeMake(56, 56));
        make.bottom.equalTo(@-20);
    }];
    
    [self.invitedButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(56, 56));
        make.bottom.equalTo(@-20);
        make.centerX.equalTo(self.userIconView).with.offset(@-38);
    }];
    
    [self.ignoreButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(self.invitedButton);
        make.centerY.equalTo(self.invitedButton);
        make.centerX.equalTo(self.userIconView).with.offset(@38);
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.and.top.equalTo(@0);
        
        if (ZYScreenWidth == 320) {
            
            make.height.equalTo(self.userIconView.mas_height).multipliedBy(0.6);
        }else{
            
            make.height.equalTo(self.userIconView.mas_height).multipliedBy(0.46);
        }
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
//    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:model.organizer.avatar] placeholderImage:CPPlaceHolderImage options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        self.userIconView.image = [image blurredImageWithRadius:10];
//    }];
    
    [self.distanceView setTitle:[NSString stringWithFormat:@"%zdm",model.distance] forState:UIControlStateNormal];
    
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

- (void)setOneType:(BOOL)oneType
{
    _oneType = oneType;
    if (oneType) {
        self.dateButton.hidden = NO;
        self.invitedButton.hidden = YES;
        self.ignoreButton.hidden = YES;
        [self dateAnim];
        [self.ignoreAnim removeFromSuperlayer];
        [self.inviAnim removeFromSuperlayer];
    }else{
        self.dateButton.hidden = YES;
        self.invitedButton.hidden = NO;
        self.ignoreButton.hidden = NO;
        [self.dateAnim removeFromSuperlayer];
        [self inviAnim];
        [self ignoreAnim];
    }
}

#pragma mark - 处理cell事件

/**
 *  点击距离按钮
 */
- (IBAction)distanceClick:(id)sender {
    [self superViewWillRecive:DistanceBtnClickKey info:nil];
}

- (IBAction)loveClick:(UIButton *)sender {
    
    if (CPUnLogin) {
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"user/%@/listen?token=%@",CPUserId, CPToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"targetUserId"] = _model.organizer.userId;
    params[@"token"] = CPToken;
    
    if (sender.isSelected) {
        
        url = [NSString stringWithFormat:@"user/%@/unlisten?token=%@",CPUserId, CPToken];
        
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            DLog(@"%@取消成功",responseObject);
            if (CPSuccess) {
                
                [sender addAnimation:[CAAnimation scaleFrom:1.0 toScale:1.1 durTimes:0.2 rep:1]];
                sender.selected = NO;
            }
        } failed:^(NSError *error) {
            
        }];
        
    }else{
        
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            
            DLog(@"%@关注成功",responseObject);
            if (CPSuccess){
                
                [sender addAnimation:[CAAnimation scaleFrom:1.0 toScale:1.2 durTimes:0.2 rep:1]];
                sender.selected = YES;
            }
        } failed:^(NSError *error) {
            
        }];
    }
    
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
            [self superViewWillRecive:DateBtnClickKey info:_model];
        }];
    }
    return _dateButton;
}

- (UIButton *)ignoreButton
{
    if (_ignoreButton == nil) {
        _ignoreButton = [UIButton buttonWithTitle:@"忽略" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        _ignoreButton.backgroundColor = [Tools getColor:@"cccccc"];
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
        CGFloat y = (ZYScreenWidth - 20) / 6.0 * 5.0 - 48;
        _dateAnim.position = CGPointMake(x, y);
        [self.userIconView.layer insertSublayer:_dateAnim below:_dateButton.layer];
    }
    return _dateAnim;
}


- (MultiplePulsingHaloLayer *)inviAnim
{
    if (_inviAnim == nil) {
        
        _inviAnim = [self multiLayer];
        
        CGFloat x = (ZYScreenWidth - 20) * 0.5 - 38;
        CGFloat y = (ZYScreenWidth - 20) / 6.0 * 5.0 - 48;
        _inviAnim.position = CGPointMake(x, y);
        [self.userIconView.layer insertSublayer:_inviAnim below:_invitedButton.layer];
    }
    return _inviAnim;
}


- (MultiplePulsingHaloLayer *)ignoreAnim
{
    if (_ignoreAnim == nil) {
        
        _ignoreAnim = [self multiLayer];
        _ignoreAnim.haloLayerColor = [Tools getColor:@"cccccc"].CGColor;
        CGFloat x = (ZYScreenWidth - 20) * 0.5 + 38;
        CGFloat y = (ZYScreenWidth - 20) / 6.0 * 5.0 - 48;
        _ignoreAnim.position = CGPointMake(x, y);
        [self.userIconView.layer insertSublayer:_ignoreAnim below:_ignoreButton.layer];
    }
    return _ignoreAnim;
}

- (MultiplePulsingHaloLayer *)multiLayer
{
    MultiplePulsingHaloLayer *multiLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:0.5];
    multiLayer.fromValueForRadius = 0.5;
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
- (UIImageView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIImageView alloc] init];
        _tipView.userInteractionEnabled = YES;
        _tipView.image = [UIImage imageNamed:@"bg_pic"];
        
        
        CPNoHighLightButton *uploadBtn = [CPNoHighLightButton buttonWithType:UIButtonTypeCustom];
        uploadBtn.titleLabel.font = ZYFont14;
        [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
        [uploadBtn setBackgroundImage:[UIImage imageNamed:@"btn_pic"] forState:UIControlStateNormal];
        [_tipView addSubview:uploadBtn];
        [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@15);
            make.size.equalTo(CGSizeMake(58, 30));
        }];
        
        UILabel *textL = [UILabel new];
        textL.text = @"上传照片即可查看Ta的照片呦~";
        textL.textColor = [UIColor whiteColor];
        textL.font = ZYFont14;
        textL.textAlignment = NSTextAlignmentRight;
        [textL sizeToFit];
        [_tipView addSubview:textL];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(uploadBtn.mas_left).with.offset(-10);
            make.centerY.equalTo(uploadBtn);
        }];
        
        CPNoHighLightButton *cameraBtn = [CPNoHighLightButton buttonWithType:UIButtonTypeCustom];
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
        [[cameraBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self superViewWillRecive:CameraBtnClickKey info:nil];
        }];
        
        CPNoHighLightButton *photoBtn = [CPNoHighLightButton buttonWithType:UIButtonTypeCustom];
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
        [[photoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self superViewWillRecive:PhotoBtnClickKey info:nil];
        }];
        
        [[uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (cameraBtn.alpha == 0){
                [cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(uploadBtn.mas_bottom).offset(10);
                }];
                
                [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(cameraBtn.mas_bottom).offset(10);
                }];
            }else{
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
                
                cameraBtn.alpha = !cameraBtn.alpha;
                photoBtn.alpha = !photoBtn.alpha;
                [_tipView layoutIfNeeded];
            }];
            
        }];
       
    }
    return _tipView;
}

@end
