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
#import "DRNRealTimeBlurView.h"
#import "UIImageView+webCache.h"

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
 *  请我吧label的left
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewLeftCons;


/**
 *  请客的View
 */
@property (weak, nonatomic) IBOutlet UILabel *payView;

/**
 *  显示用户大图的View
 */
@property (weak, nonatomic) IBOutlet ZYImageVIew *userIconView;

/**
 *  显示地点的View
 */
@property (weak, nonatomic) IBOutlet UIButton *addressView;
/**
 *  显示距离的view
 */
@property (weak, nonatomic) IBOutlet UIButton *distanceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLWCons;

@property (weak, nonatomic) IBOutlet UIButton *titleDistanceView;

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
 *  应邀的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *inviAnim;

/**
 *  忽略的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *ignoreAnim;

@property (nonatomic, assign) BOOL oneType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginCons;

/**
 *  显示message
 */
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *titleExtraText;

@end

@implementation CPBaseViewCell

#pragma mark - 初始化方法
+ (instancetype)baseCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"CPBaseViewCell" owner:nil options:nil].lastObject;;
}

- (void)awakeFromNib
{
    self.titleView.hidden = YES;
    
    self.titleDistanceView.hidden = YES;
    
    self.titleLWCons.constant = ZYScreenWidth - 150;
    // 进行初始化设置
    [self.bgView setCornerRadius:5];
    self.distanceView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes.rac_gestureSignal subscribeNext:^(id x) {
        
        [self superViewWillRecive:IconViewClickKey info:_indexPath];
    }];
    [self.userIconView addGestureRecognizer:tapGes];
    [self.userIconView addSubview:self.tipView];
    [self.userIconView addSubview:self.dateButton];
    [self.userIconView addSubview:self.invitedButton];
    [self.userIconView addSubview:self.ignoreButton];
    [self.userIconView addSubview:self.changeImg];
    [self.userIconView addSubview:self.continueMatching];
    [self dateAnim];
    [self.bgView addSubview:self.titleView];
    [self.titleView addSubview:self.titleExtraText];
    
    self.titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapL = [[UITapGestureRecognizer alloc] init];
    [tapL.rac_gestureSignal subscribeNext:^(id x) {
        if ([_myDateModel.activityCategory isEqualToString:@"邀请同去"]) {
            [self superViewWillRecive:TitleLabelClickKey info:_myDateModel.activityId];
        }
    }];
    [self.titleLabel addGestureRecognizer:tapL];
}

#pragma mark - 布局方法
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
    
    [self.changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(87, 34));
        make.bottom.equalTo(@-10);
        make.centerX.equalTo(@-52);
    }];
    
    [self.continueMatching mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(87, 34));
        make.bottom.equalTo(@-10);
        make.centerX.equalTo(@52);
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.and.top.equalTo(@0);
        
        if (ZYScreenWidth == 320) {
            
            make.height.equalTo(self.userIconView.mas_height).multipliedBy(0.6);
        }else{
            
            make.height.equalTo(self.userIconView.mas_height).multipliedBy(0.46);
        }
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.userIconView);
        make.height.equalTo(@30);
    }];
    
    [self.titleExtraText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.titleView);
    }];
}

#pragma mark - 设置数据
/**
 *  根据model设置cell展示的数据
 *
 *  @param model model description
 */
- (void)setModel:(CPActivityModel *)model
{
    _model = model;
    
    if (model.isHisDate) {
        self.marginCons.constant = 0;
    }else{
        self.marginCons.constant = 20;
    }
    BOOL isHasAlubm;
    if (CPUnLogin) {
        isHasAlubm = NO;
    }else{
        isHasAlubm = [ZYUserDefaults boolForKey:CPHasAlbum];
    }
    self.sexView.isMan = model.organizer.isMan;
    self.sexView.age = model.organizer.age;

    if (model.organizer.cover) {
        [self.userIconView zy_setBlurImageWithUrl:[model.organizer.cover stringByAppendingString:@"?imageView2/1/w/500"]];
    }else{
        [self.userIconView setImage:[UIImage imageNamed:@"logo"]];
    }
    [self.distanceView setTitle:model.distanceStr.trimLength?model.distanceStr:@"未知" forState:UIControlStateNormal];
    self.loveBtn.selected = model.organizer.subscribeFlag;

    
    if (model.pay.trimLength){
        self.payView.text = model.pay;
        self.payViewLeftCons.constant = 10;
    }else{
        self.payViewLeftCons.constant = 0;
        self.payView.text = @"";
    }
    self.sendView.hidden = !model.transfer;
    
    NSString *street = model.destination[@"street"];
    
    if (street.trimLength) {
        street = [NSString stringWithFormat:@"%@周边",street];
    }else{
        street = @"地点待定";
    }
    [self.addressView setTitle:street forState:UIControlStateNormal];
    if (model.title.length) {
        self.titleLabel.text = model.title;
        CGFloat width = [model.title sizeWithFont:self.titleLabel.font].width + 2;
        if (width > ZYScreenWidth - 100) {
            self.titleLWCons.constant = ZYScreenWidth - 100;
        }else{
            self.titleLWCons.constant = width;
        }
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
        [self.carView zySetImageWithUrl:model.organizer.car.logo placeholderImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }else{
        self.carView.hidden = YES;
//        [self.carView setImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }
    // 上传相册的View
    if (isHasAlubm && CPIsLogin) {
        self.tipView.hidden = YES;
    }else{
        self.tipView.hidden = NO;
    }
    NSInteger status;
    if (model.isHisDate) {
        status = model.status;
    }else{
        status = model.applyFlag;
    }
    if (model.activityId) {
        if (status == 0){
            if (model.isHisDate) {
                
                if (model.organizer.idle) {
                    self.dateAnim.haloLayerColor = RedColor.CGColor;
                    [self.dateButton setBackgroundColor:RedColor];
                    [self.dateButton setTitle:@"邀Ta" forState:UIControlStateNormal];
                    [self setOneType:YES];
                }else{
                    
                    self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
                    [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
                    [self.dateButton setTitle:@"Ta没空" forState:UIControlStateNormal];
                    [self setOneType:YES];
                }
            }else{
                self.dateAnim.haloLayerColor = RedColor.CGColor;
                [self.dateButton setBackgroundColor:RedColor];
                [self.dateButton setTitle:@"邀Ta" forState:UIControlStateNormal];
                [self setOneType:YES];
            }
        }else if (status == 1 || status == 3){
            
            if ([model.organizer.userId isEqualToString:CPUserId]) {
                [self setOneType:NO];
                [self setPhoneType:NO];
            }else{
                
                self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
                [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
                [self.dateButton setTitle:@"邀请中" forState:UIControlStateNormal];
                [self setOneType:YES];
            }
        }else if (status == 2){
            [self setPhoneType:YES];
        }
    }
}

- (void)setMyDateModel:(CPMyDateModel *)myDateModel
{
    _myDateModel = myDateModel;

    self.marginCons.constant = 0;
    BOOL isHasAlubm;
    if (CPUnLogin) {
        isHasAlubm = NO;
    }else{
        isHasAlubm = [ZYUserDefaults boolForKey:CPHasAlbum];
    }
    self.sexView.isMan = myDateModel.applicant.isMan;
    self.sexView.age = myDateModel.applicant.age;
    
    [self.userIconView zy_setBlurImageWithUrl:[myDateModel.applicant.cover stringByAppendingString:@"?imageView2/1/w/500"]];
    
    [self.distanceView setTitle:myDateModel.distanceStr.trimLength ? myDateModel.distanceStr : @"未知" forState:UIControlStateNormal];
    self.loveBtn.selected = myDateModel.applicant.subscribeFlag;
    
    if (myDateModel.pay.trimLength){
        self.payViewLeftCons.constant = 10;
        self.payView.text = myDateModel.pay;
    }else{
        self.payViewLeftCons.constant = 0;
        self.payView.text = @"";
    }
    
    self.sendView.hidden = !myDateModel.transfer;
    NSString *street = myDateModel.destination[@"street"];
    
    if (street.trimLength) {
        street = [NSString stringWithFormat:@"%@周边",street];
    }else{
        street = @"地点待定";
    }
    [self.addressView setTitle:street forState:UIControlStateNormal];
    if (myDateModel.title.length) {
        
        self.titleLabel.attributedText = myDateModel.title;
        CGFloat width = [myDateModel.title.string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : ZYFont16} context:NULL].size.width;
        if (width > ZYScreenWidth - 100) {
            self.titleLWCons.constant = ZYScreenWidth - 100;
        }else{
            self.titleLWCons.constant = width;
        }
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
        [self.carView zySetImageWithUrl:myDateModel.applicant.car.logo placeholderImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }else{
        self.carView.hidden = YES;
//        [self.carView setImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }
    if (isHasAlubm && CPIsLogin) {
        self.tipView.hidden = YES;
    }else{
        self.tipView.hidden = NO;
    }
    
    if (myDateModel.status == 0){
        
        self.dateAnim.haloLayerColor = RedColor.CGColor;
        [self.dateButton setBackgroundColor:RedColor];
        [self.dateButton setTitle:@"邀Ta" forState:UIControlStateNormal];
        [self setOneType:YES];
    }else if (myDateModel.status == 1 || myDateModel.status == 3){
        
        if ([myDateModel.invitedUserId isEqualToString:CPUserId]) {
            [self setOneType:NO];
            [self setPhoneType:NO];
        }else{
            
            self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
            [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
            [self.dateButton setTitle:@"邀请中" forState:UIControlStateNormal];
            [self setOneType:YES];
        }
    }else if (myDateModel.status == 2){
        [self setPhoneType:YES];
    }else if (myDateModel.status == 4){ // 失效状态
        [self setOneType:YES];
        self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
        [self.dateButton setTitle:@"已失效" forState:UIControlStateNormal];
        [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
    }
    
    if (myDateModel.message.trimLength) {
        self.titleView.hidden = NO;
        self.titleExtraText.text = [NSString stringWithFormat:@"附加消息: %@",myDateModel.message];
    }else{
        self.titleView.hidden = YES;
    }

}

- (void)setIntersterModel:(CPIntersterModel *)intersterModel
{
    _intersterModel = intersterModel;
    self.marginCons.constant = 0;
    BOOL isHasAlubm;
    if (CPUnLogin) {
        isHasAlubm = NO;
    }else{
        isHasAlubm = [ZYUserDefaults boolForKey:CPHasAlbum];
    }
    self.sexView.isMan = intersterModel.user.isMan;
    self.sexView.age = intersterModel.user.age;
    
    [self.userIconView zy_setBlurImageWithUrl:[intersterModel.user.cover stringByAppendingString:@"?imageView2/1/w/500"]];
    self.loveBtn.hidden = YES;
    self.payView.text = intersterModel.activityPay;
    
    if (intersterModel.activityPay.trimLength){
        self.payViewLeftCons.constant = 10;
        self.payView.text = intersterModel.activityPay;
    }else{
        self.payViewLeftCons.constant = 0;
        self.payView.text = @"";
    }
    NSString *street = intersterModel.activityDestination[@"street"];
    
    if (street.trimLength) {
        street = [NSString stringWithFormat:@"%@周边",street];
    }else{
        street = @"地点待定";
    }
    [self.addressView setTitle:street forState:UIControlStateNormal];
    
    [self.titleDistanceView setTitle:intersterModel.distanceStr.trimLength?[NSString stringWithFormat:@" %@",intersterModel.distanceStr] :@" 未知" forState:UIControlStateNormal];
    [self.distanceView setTitle:intersterModel.distanceStr.trimLength?intersterModel.distanceStr:@" 未知" forState:UIControlStateNormal];
    NSString *titleStr = intersterModel.title;

    if (intersterModel.type == 1) {
        titleStr = [NSString stringWithFormat:@"%@上传了%zd张照片",intersterModel.user.nickname,intersterModel.photoCount];
    }
    
    if (titleStr.length) {
        self.titleLabel.text = titleStr;
        CGFloat width = [titleStr sizeWithFont:self.titleLabel.font].width + 5;
        if (width > ZYScreenWidth - 100) {
            self.titleLWCons.constant = ZYScreenWidth - 100;
        }else{
            self.titleLWCons.constant = width;
        }
    }else{
        self.titleLabel.text = @"";
    }
    
    if ([intersterModel.user.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.authView setImage:[UIImage imageNamed:@"头像已认证"] forState:UIControlStateNormal];
    }else{
        [self.authView setImage:[UIImage imageNamed:@"未认证-审核中"] forState:UIControlStateNormal];
    }
    
    if ([intersterModel.user.licenseAuthStatus isEqualToString:@"认证通过"]) {
        self.carView.hidden = NO;
        [self.carView zySetImageWithUrl:intersterModel.user.car.logo placeholderImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }else{
        self.carView.hidden = YES;
//        [self.carView setImage:[UIImage imageNamed:@"车主未认证"] forState:UIControlStateNormal];
    }
    if (isHasAlubm && CPIsLogin) {
        self.tipView.hidden = YES;
    }else{
        self.tipView.hidden = NO;
    }
    
    // 区分是上传相册还是发出活动
    if (intersterModel.type == 0) {
        // 活动信息
        self.titleDistanceView.hidden = YES;
        self.distanceView.hidden = NO;
        self.addressView.hidden = NO;
        self.dateButton.hidden = NO;
        self.dateAnim.hidden = NO;
        self.payView.hidden = NO;
        self.sendView.hidden = !intersterModel.activityTransfer;
        if (intersterModel.activityStatus == 0){
            
            self.dateAnim.haloLayerColor = RedColor.CGColor;
            [self.dateButton setBackgroundColor:RedColor];
            [self.dateButton setTitle:@"邀Ta" forState:UIControlStateNormal];
            [self setOneType:YES];
        }else if (intersterModel.activityStatus == 1 || intersterModel.activityStatus == 3){
            
            self.dateAnim.haloLayerColor= [Tools getColor:@"cccccc"].CGColor;
            [self.dateButton setBackgroundColor:[Tools getColor:@"cccccc"]];
            [self.dateButton setTitle:@"邀请中" forState:UIControlStateNormal];
            [self setOneType:YES];
        }else if (intersterModel.activityStatus == 2){
            [self setPhoneType:YES];
            [self setOneType:NO];
        }

    }else if (intersterModel.type == 1){
        // 上传相册信息
        self.titleDistanceView.hidden = NO;
        self.distanceView.hidden = YES;
        self.addressView.hidden = YES;
        self.dateButton.hidden = YES;
        self.dateAnim.hidden = YES;
        self.payView.hidden = YES;
        self.sendView.hidden = YES;
    }

}

/**
 *  是否显示一个按钮
 *
 *  @param oneType bool
 */
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
    if (!_model.organizer.userId) {
        params[@"targetUserId"] = _myDateModel.applicant.userId;
    }else{
        params[@"targetUserId"] = _model.organizer.userId;
    }
    
    if (sender.isSelected) {
        
        url = [NSString stringWithFormat:@"user/%@/unlisten?token=%@",CPUserId, CPToken];
        [SVProgressHUD showWithStatus:@"努力加载中"];
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if (CPSuccess) {
                DLog(@"取消关注成功");
                sender.selected = NO;
                [sender addAnimation:[CAAnimation scaleFrom:1.0 toScale:1.2 durTimes:0.2 rep:1]];
                if (_model.organizer.userId) {
                    
                    _model.organizer.subscribeFlag = 0;
                }else{
                    
                    _myDateModel.applicant.subscribeFlag = 0;
                }
                
                [self superViewWillRecive:LoveBtnClickKey info:_indexPath];
            }else{
                [SVProgressHUD showInfoWithStatus:CPErrorMsg];
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
                if (_model.organizer.userId) {
                    
                    _model.organizer.subscribeFlag = 1;
                }else{
                    
                    _myDateModel.applicant.subscribeFlag = 1;
                }
                [self superViewWillRecive:LoveBtnClickKey info:_indexPath];
            }else{
                [SVProgressHUD showInfoWithStatus:CPErrorMsg];
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
        _invitedButton = [UIButton buttonWithTitle:@"应邀" icon:nil titleColor:[Tools getColor:@"ffffff"] fontSize:16];
        
        _invitedButton.layer.cornerRadius = 28;
        _invitedButton.clipsToBounds = YES;
        _invitedButton.hidden = YES;
        ZYWeakSelf
        [[_invitedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            if (_myDateModel.status == 1){
                
                if ([_myDateModel.invitedUserId isEqualToString:CPUserId]) {
                    
                    NSString *url = [NSString stringWithFormat:@"application/%@/process?userId=%@&token=%@", _myDateModel.appointmentId, CPUserId, CPToken];
                    [SVProgressHUD showWithStatus:@"努力加载中"];
                    [ZYNetWorkTool postJsonWithUrl:url params:@{@"accept" : @(YES)} success:^(id responseObject) {
                        if (CPSuccess) {
                            [SVProgressHUD dismiss];
                            _myDateModel.status = 2;
                            [self setPhoneType:YES];
                        }else{
                            [SVProgressHUD showInfoWithStatus:CPErrorMsg];
                        }
                    } failed:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"加载失败"];
                    }];
                    
                }else{
                    
                }
            }
            else if (_myDateModel.status == 2 || _model.status ==2 || _intersterModel.activityStatus == 2){
                
                [self superViewWillRecive:InvitedButtonClickKey info:_indexPath];
            }
        }];
    }
    return _invitedButton;
}

- (UIButton *)dateButton
{
    if (_dateButton == nil) {
        _dateButton = [UIButton buttonWithTitle:@"邀Ta" icon:nil titleColor:[Tools getColor:@"ffffff"] fontSize:16];
        _dateButton.backgroundColor = RedColor;
        
        _dateButton.layer.cornerRadius = 28;
        _dateButton.clipsToBounds = YES;
        [[_dateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([[x currentTitle] isEqualToString:@"邀请中"] || [[x currentTitle] isEqualToString:@"Ta没空"]) {
                return;
            }
            [self superViewWillRecive:DateBtnClickKey info:_indexPath];
        }];
        if (!_model.activityId) {
            [_dateButton setHidden:YES];
        }
        
    }
    return _dateButton;
}

- (UIButton *)ignoreButton
{
    if (_ignoreButton == nil) {
        _ignoreButton = [UIButton buttonWithTitle:@"忽略" icon:nil titleColor:[Tools getColor:@"ffffff"] fontSize:16];
        _ignoreButton.layer.cornerRadius = 28;
        _ignoreButton.clipsToBounds = YES;
        _ignoreButton.hidden = YES;
        ZYWeakSelf
        [[_ignoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            if (_myDateModel.status == 1){
                
                if ([_myDateModel.invitedUserId isEqualToString:CPUserId]) {
                    [SVProgressHUD showWithStatus:@"努力加载中"];
                    NSString *url = [NSString stringWithFormat:@"application/%@/process?userId=%@&token=%@", _myDateModel.appointmentId, CPUserId, CPToken];
                    [ZYNetWorkTool postJsonWithUrl:url params:@{@"accept" : @(NO)} success:^(id responseObject) {
                        NSLog(@"%@",responseObject);
                        if (CPSuccess) {
                            
                            [SVProgressHUD dismiss];
                            [self superViewWillRecive:IgnoreButtonClickKey info:_indexPath];
                        }else{
                            [SVProgressHUD showInfoWithStatus:CPErrorMsg];
                        }
                    } failed:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"加载失败"];
                    }];
                    
                }else{
                    
                }
            }
            else if (_myDateModel.status == 2 || _model.status ==2 || _intersterModel.activityStatus == 2){
                [self superViewWillRecive:IgnoreButtonClickKey info:_indexPath];
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
            CPGoLogin(@"上传");
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

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [UIView new];
        _titleView.backgroundColor = ZYColor(0, 0, 0, 0.5);
    }
    return _titleView;
}

- (UILabel *)titleExtraText
{
    if (!_titleExtraText) {
        _titleExtraText = [UILabel new];
        _titleExtraText.textColor = [UIColor whiteColor];
        _titleExtraText.font = ZYFont12;
        [_titleExtraText sizeToFit];
    }
    return _titleExtraText;
}

-(UIButton *)changeImg{
    if (_changeImg == nil) {
        _changeImg = [UIButton buttonWithTitle:@"更换照片" icon:nil titleColor:[Tools getColor:@"ffffff"] fontSize:14];
        _changeImg.layer.cornerRadius = 17;
        _changeImg.clipsToBounds = YES;
        _changeImg.hidden = YES;
        [_changeImg setBackgroundColor:[UIColor colorWithRed:254/255.0 green:89/255.0 blue:105/255.0 alpha:.9]];
    }
    return _changeImg;
}

-(UIButton *)continueMatching{
    if (_continueMatching == nil) {
        _continueMatching = [UIButton buttonWithTitle:@"继续匹配" icon:nil titleColor:[Tools getColor:@"ffffff"] fontSize:14];
        _continueMatching.layer.cornerRadius = 17;
        _continueMatching.clipsToBounds = YES;
        _continueMatching.hidden=YES;
        [_continueMatching setBackgroundColor:[UIColor colorWithRed:119/255.0 green:187/255.0 blue:242/255.0 alpha:.9]];
    }
    return _continueMatching;
}

@end
