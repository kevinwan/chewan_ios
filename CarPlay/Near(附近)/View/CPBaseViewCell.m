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
#import "ZYImageVIew.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"

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
 *  关注的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

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
@property (weak, nonatomic) IBOutlet ZYImageVIew *userIconView;

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

@property (nonatomic, assign) BOOL oneType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginCons;

@end

@implementation CPBaseViewCell

- (void)awakeFromNib
{
    self.marginCons.constant = 12;
    // 进行初始化设置
    [self.bgView setCornerRadius:5];
    self.distanceView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes.rac_gestureSignal subscribeNext:^(id x) {
        
        [self superViewWillRecive:IconViewClickKey info:_model];
    }];
    [self.userIconView addGestureRecognizer:tapGes];
    [self.userIconView addSubview:self.tipView];
    [self.userIconView addSubview:self.dateButton];
    [self.userIconView addSubview:self.invitedButton];
    [self.userIconView addSubview:self.ignoreButton];
    [self dateAnim];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self beginLayoutSubviews];
}

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
    BOOL isHasAlubm;
    if (CPUnLogin) {
        isHasAlubm = NO;
    }else{
        isHasAlubm = [ZYUserDefaults boolForKey:CPHasAlbum];
    }
    self.sexView.isMan = model.organizer.isMan;
    self.sexView.age = model.organizer.age;

    
    [self.userIconView zy_setImageWithUrl:model.organizer.cover completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ZYAsyncThead(^{
            UIImage *img = nil;
            if (isHasAlubm) {
                img = image;
            }else{
                img = [image blurredImageWithRadius:20.0 iterations:1 tintColor:[UIColor clearColor]];
            }
            
            ZYMainThread(^{
                self.userIconView.image = img;
            });
        });
    }];
    [self.distanceView setTitle:model.distanceStr forState:UIControlStateNormal];
    self.loveBtn.selected = model.organizer.subscribeFlag;
    self.payView.text = model.pay;
    self.sendView.hidden = !model.transfer;
    if ([model.destination isKindOfClass:[NSDictionary class]]) {
        [self.addressView setTitle:model.destination[@"street"] forState:UIControlStateNormal];
    }
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
    if (isHasAlubm && CPIsLogin) {
        self.tipView.hidden = YES;
    }else{
        self.tipView.hidden = NO;
    }
    
    if (model.applyFlag == 0){
        
        self.dateAnim.haloLayerColor = RedColor.CGColor;
        [self.dateButton setBackgroundColor:RedColor];
        [self.dateButton setTitle:@"邀TA" forState:UIControlStateNormal];
        [self setOneType:YES];
    }else if (model.applyFlag == 1){
        
        if ([model.organizer.userId isEqualToString:CPUserId]) {
            [self setOneType:NO];
            [self setPhoneType:NO];
        }else{
            
            self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
            [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
            [self.dateButton setTitle:@"已邀请" forState:UIControlStateNormal];
            [self setOneType:YES];
        }
    }else if (model.applyFlag == 2){
        [self setPhoneType:YES];
    }
}

- (void)setMyDateModel:(CPMyDateModel *)myDateModel
{
    _myDateModel = myDateModel;
    BOOL isHasAlubm;
    if (CPUnLogin) {
        isHasAlubm = NO;
    }else{
        isHasAlubm = [ZYUserDefaults boolForKey:CPHasAlbum];
    }
    self.sexView.isMan = myDateModel.applicant.isMan;
    self.sexView.age = myDateModel.applicant.age;
    
    
    [self.userIconView zy_setImageWithUrl:myDateModel.applicant.cover completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ZYAsyncThead(^{
            UIImage *img = nil;
            if (isHasAlubm) {
                img = image;
            }else{
                img = [image blurredImageWithRadius:20.0 iterations:1 tintColor:[UIColor clearColor]];
            }
            
            ZYMainThread(^{
                self.userIconView.image = img;
            });
        });
    }];
    [self.distanceView setTitle:myDateModel.distanceStr forState:UIControlStateNormal];
    self.loveBtn.selected = myDateModel.applicant.subscribeFlag;
    self.payView.text = myDateModel.pay;
    self.sendView.hidden = !myDateModel.transfer;
    if ([myDateModel.destination isKindOfClass:[NSDictionary class]]) {
        [self.addressView setTitle:myDateModel.destination[@"street"] forState:UIControlStateNormal];
    }
    if (myDateModel.title.length) {
        self.titleLabel.text = myDateModel.title;
    }else{
        self.titleLabel.text = @"";
    }
    
    if ([myDateModel.applicant.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.authView setImage:[UIImage imageNamed:@"头像已认证"] forState:UIControlStateNormal];
    }else{
        [self.authView setImage:[UIImage imageNamed:@"未认证-审核中"] forState:UIControlStateNormal];
    }
    
    if ([myDateModel.applicant.licenseAuthStatus isEqualToString:@"认证通过"]) {
        self.carView.hidden = NO;
        self.carTypeView.hidden = NO;
        [self.carView sd_setImageWithURL:[NSURL URLWithString:myDateModel.applicant.car.logo] forState:UIControlStateNormal placeholderImage:CPPlaceHolderImage];
        self.carTypeView.text = myDateModel.applicant.car.model;
    }else{
        self.carView.hidden = YES;
        self.carTypeView.hidden = YES;
    }
    if (isHasAlubm && CPIsLogin) {
        self.tipView.hidden = YES;
    }else{
        self.tipView.hidden = NO;
    }
    
    if (myDateModel.status == 0){
        
        self.dateAnim.haloLayerColor = RedColor.CGColor;
        [self.dateButton setBackgroundColor:RedColor];
        [self.dateButton setTitle:@"邀TA" forState:UIControlStateNormal];
        [self setOneType:YES];
    }else if (myDateModel.status == 1){
        
        if ([myDateModel.invitedUserId isEqualToString:CPUserId]) {
            [self setOneType:NO];
            [self setPhoneType:NO];
        }else{
            
            self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
            [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
            [self.dateButton setTitle:@"已邀请" forState:UIControlStateNormal];
            [self setOneType:YES];
        }
    }else if (myDateModel.status == 2){
        [self setPhoneType:YES];
    }

}

- (void)setOneType:(BOOL)oneType
{
    _oneType = oneType;
    if (oneType) {
        self.dateButton.hidden = NO;
        self.dateAnim.hidden = NO;
        self.invitedButton.hidden = YES;
        self.ignoreButton.hidden = YES;
        self.ignoreAnim.hidden = YES;
        self.inviAnim.hidden = YES;
    }else{
        self.dateButton.hidden = YES;
        self.dateAnim.hidden = YES;
        self.invitedButton.hidden = NO;
        self.ignoreButton.hidden = NO;
        self.ignoreAnim.hidden = NO;
        self.inviAnim.hidden = NO;
    }
}

- (void)setPhoneType:(BOOL)phoneType
{
    if (phoneType) {
        [self setOneType:NO];
        self.inviAnim.haloLayerColor = [Tools getColor:@"77bbf2"].CGColor;
        self.ignoreAnim.haloLayerColor = [Tools getColor:@"98d872"].CGColor;
        self.invitedButton.selected = YES;
        [self.invitedButton setBackgroundColor:[Tools getColor:@"77bbf2"]];
        [_invitedButton setTitle:@"" forState:UIControlStateNormal];
        [_invitedButton setImage:[UIImage imageNamed:@"聊天-1"] forState:UIControlStateNormal];
        self.ignoreButton.selected = YES;
        [self.ignoreButton setBackgroundColor:[Tools getColor:@"98d872"]];
        [_ignoreButton setImage:[UIImage imageNamed:@"电话-1"] forState:UIControlStateNormal];
        [_ignoreButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        self.inviAnim.haloLayerColor = RedColor.CGColor;
        self.ignoreAnim.haloLayerColor = [Tools getColor:@"cccccc"].CGColor;
        self.invitedButton.selected = NO;
        [self.invitedButton setBackgroundColor:RedColor];
        [_invitedButton setTitle:@"应邀" forState:UIControlStateNormal];
        [_invitedButton setImage:nil forState:UIControlStateNormal];
        self.ignoreButton.selected = NO;
        [self.ignoreButton setBackgroundColor:[Tools getColor:@"cccccc"]];
        
        [_ignoreButton setImage:nil forState:UIControlStateNormal];
        [_ignoreButton setTitle:@"忽略" forState:UIControlStateNormal];
    }
}

#pragma mark - 处理cell事件

/**
 *  点击距离按钮
 */
- (IBAction)distanceClick:(id)sender {

}

- (IBAction)loveClick:(UIButton *)sender {
    
    CPGoLogin(@"关注");
    NSString *url = [NSString stringWithFormat:@"user/%@/listen?token=%@",CPUserId, CPToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"targetUserId"] = _model.organizer.userId;
    params[@"token"] = CPToken;
    
    if (sender.isSelected) {
        
        url = [NSString stringWithFormat:@"user/%@/unlisten?token=%@",CPUserId, CPToken];
        [SVProgressHUD showWithStatus:@"努力加载中"];
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if (CPSuccess) {
                DLog(@"取消关注成功");
                sender.selected = NO;
                [sender addAnimation:[CAAnimation scaleFrom:1.0 toScale:1.2 durTimes:0.2 rep:1]];
                _model.organizer.subscribeFlag = 0;
                [self superViewWillRecive:LoveBtnClickKey info:_model];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD dismiss];
            DLog(@"取消关注失败%@",error);
        }];
        
    }else{
        [SVProgressHUD showWithStatus:@"努力加载中"];
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if (CPSuccess){
                
                DLog(@"关注成功");
                sender.selected = YES;
                [sender addAnimation:[CAAnimation scaleFrom:1.0 toScale:1.2 durTimes:0.2 rep:1]];
                _model.organizer.subscribeFlag = 1;
                [self superViewWillRecive:LoveBtnClickKey info:_model];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"关注失败"];
        }];
    }
}


#pragma mark - lazy
- (UIButton *)invitedButton
{
    if (_invitedButton == nil) {
        _invitedButton = [UIButton buttonWithTitle:@"应邀" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        
        _invitedButton.layer.cornerRadius = 28;
        _invitedButton.clipsToBounds = YES;
        _invitedButton.hidden = YES;
        ZYWeakSelf
        [[_invitedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            if (_myDateModel.status == 1){
                
                if ([_myDateModel.invitedUserId isEqualToString:CPUserId]) {
                    
                    NSString *url = [NSString stringWithFormat:@"application/%@/process?userId=%@&token=%@", _myDateModel.appointmentId, CPUserId, CPToken];
                    [ZYNetWorkTool postJsonWithUrl:url params:@{@"accept" : @(YES)} success:^(id responseObject) {
                        if (CPSuccess) {
                            [self setPhoneType:YES];
                        }
                    } failed:^(NSError *error) {
                        
                    }];
                    
                }else{
                    
                }
            }else if (_myDateModel.status == 2){
                
                [self superViewWillRecive:InvitedButtonClickKey info:_indexPath];
            }
            
            if ([_myDateModel.invitedUserId isEqualToString:CPUserId]) {
                
            }
        }];
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
            [self superViewWillRecive:DateBtnClickKey info:_indexPath];
        }];
    }
    return _dateButton;
}

- (UIButton *)ignoreButton
{
    if (_ignoreButton == nil) {
        _ignoreButton = [UIButton buttonWithTitle:@"忽略" icon:nil titleColor:[UIColor whiteColor] fontSize:16];
        _ignoreButton.layer.cornerRadius = 28;
        _ignoreButton.clipsToBounds = YES;
        _ignoreButton.hidden = YES;
        ZYWeakSelf
        [[_ignoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            if (_myDateModel.status == 1){
                
                if ([_myDateModel.invitedUserId isEqualToString:CPUserId]) {
                    NSString *url = [NSString stringWithFormat:@"application/%@/process?userId=%@&token=%@", _myDateModel.appointmentId, CPUserId, CPToken];
                    [ZYNetWorkTool postJsonWithUrl:url params:@{@"accept" : @(NO)} success:^(id responseObject) {
                        NSLog(@"%@",responseObject);
                        if (CPSuccess) {
                            
                            [self superViewWillRecive:IgnoreButtonClickKey info:_indexPath];
                        }
                    } failed:^(NSError *error) {
                        
                    }];
                    
                }else{
                    
                }
            }
            else if (_myDateModel.status == 2){
                
            }
        }];
    }
    return _ignoreButton;
}

- (MultiplePulsingHaloLayer *)dateAnim
{
    if (_dateAnim == nil) {
        
        _dateAnim = [self multiLayer];
        _dateAnim.haloLayerColor = RedColor.CGColor;
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
            }else{
                [cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(uploadBtn);
                    make.top.equalTo(uploadBtn);
                }];
                
            }

            [UIView animateWithDuration:0.25 animations:^{
                cameraBtn.alpha = !cameraBtn.alpha;
               [cameraBtn layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (photoBtn.alpha == 0){
                    [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                        make.centerX.equalTo(uploadBtn);
                        make.top.equalTo(cameraBtn.mas_bottom).offset(10);
                    }];
                }else{
                    
                    [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                        make.centerX.equalTo(uploadBtn);
                        make.top.equalTo(cameraBtn);
                    }];
                }

                [UIView animateWithDuration:0.25 animations:^{
                    photoBtn.alpha = !photoBtn.alpha;
                    [photoBtn layoutIfNeeded];
                } completion:NULL];
                
            }];
            
        }];
       
    }
    return _tipView;
}

@end
