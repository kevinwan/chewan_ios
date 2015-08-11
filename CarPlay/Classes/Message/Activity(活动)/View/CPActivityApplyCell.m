//
//  CPActivityApplyCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyCell.h"
#import "CPActivityApplyModel.h"
#import "UIButton+WebCache.h"
#import "CPSexView.h"
#import "UIImageView+WebCache.h"
#import "CPActivityApplyButton.h"
#import "AppAppearance.h"

@interface CPActivityApplyCell()

@property (nonatomic, strong) UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipmsgLabel;

@property (weak, nonatomic) IBOutlet CPSexView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *carView;
@property (weak, nonatomic) IBOutlet UILabel *offerSeatLabel;
@property (weak, nonatomic) IBOutlet CPActivityApplyButton *agreeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeBtnTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipMsgLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;

@end

@implementation CPActivityApplyCell

- (void)awakeFromNib
{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)setModel:(CPActivityApplyModel *)model
{
    _model = model;
    
    [self setChecked:model.isChecked];
    if (model.photo) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else{
        [self.iconView setImage:[UIImage imageNamed:@"placeholderImage"] forState:UIControlStateNormal];
    }
    
    self.agreeBtn.selected = model.isAgree;
    
    if (model.nickname) {
        self.nameLabel.text = model.nickname;
        CGFloat nameLableW = [self.nameLabel.text sizeWithFont:self.nameLabel.font].width;
        if (nameLableW > kScreenWidth - 200) {
            self.nameLabelWidth.constant = kScreenWidth - 200;
        }else{
            self.nameLabelWidth.constant = nameLableW;
        }
    }else{
        self.nameLabel.text = @"";
        self.nameLabelWidth.constant = 0;
    }
    
    if (model.age && model.gender) {
        self.sexView.isMan = [model.gender isEqualToString:@"男"];
        self.sexView.age = model.age.unsignedIntValue;
    }
    
    if ([model.type isEqualToString:@"活动申请处理"]){
        self.tipMsgLabelWidth.constant = kScreenWidth -  150;
        if (model.carBrandLogo.length) {
            
            // 如果不提供座位则不显示
            if (model.seatText) {
                self.offerSeatLabel.attributedText = model.seatText;
                self.agreeBtnTopMargin.constant = 10;
            }else{
                // 调整同意按钮的位置为居中
                self.offerSeatLabel.attributedText = nil;
                self.agreeBtnTopMargin.constant = 20;
            }
            
            self.tipmsgLabel.attributedText = model.text;
            
            self.agreeBtnTopMargin.constant = 10;
            self.carView.hidden = NO;
            [self.carView sd_setImageWithURL:[NSURL URLWithString:model.carBrandLogo] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }else{
            self.tipmsgLabel.text = @"带我飞 ~";
            self.offerSeatLabel.text = @"";
            self.agreeBtnTopMargin.constant = 20;
            self.carView.hidden = YES;
        }
    }else{
        if (model.carBrandLogo.length){
            [self.carView sd_setImageWithURL:[NSURL URLWithString:model.carBrandLogo] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
             self.carView.hidden = NO;
        }else{
            self.carView.hidden = YES;
        }
        self.tipmsgLabel.attributedText = model.text;
    }
}

- (IBAction)agreeBtnClick:(id)sender {

    NSString *url = [NSString stringWithFormat:@"v1/application/%@/process",_model.applicationId];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[@"action"] = @(1);
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool postJsonWithUrl:url params:json success:^(id responseObject) {

        if (CPSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"已同意"];
           _model.isAgree = YES;
            [CPNotificationCenter postNotificationName:CPActivityApplyNotification object:nil userInfo:@{CPActivityApplyInfo :@(self.model.row)}];
     
        }else{
            [SVProgressHUD showInfoWithStatus:@"加载失败"];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}

- (IBAction)iconViewClick:(id)sender {
    
    if (_model.userId.length) {
        [CPNotificationCenter postNotificationName:CPClickUserIconNotification object:nil userInfo:@{CPClickUserIconInfo : _model.userId}];
    }
    
}




#pragma mark - 可以多选的tableView

/**
 *  触发多选的通知
 *
 *  @param recognizer recognizer description
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [CPNotificationCenter postNotificationName:CPNewActivityMsgEditNotifycation object:nil userInfo:@{CPNewActivityMsgEditInfo : @(self.model.row)}];
    }
}

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        self.checkImageView.center = pt;
        self.checkImageView.alpha = alpha;
        
        [UIView commitAnimations];
    }
    else
    {
        self.checkImageView.center = pt;
        self.checkImageView.alpha = alpha;
    }
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        if (self.checkImageView == nil)
        {
            self.checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选"]];
            [self addSubview:self.checkImageView];
        }
        
        [self setChecked:_checked];
        self.checkImageView.center = CGPointMake(-CGRectGetWidth(self.checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        self.checkImageView.alpha = 0.0;
        [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5) alpha:1.0 animated:animated];
    }
    else
    {
        _checked = NO;
        
        if (self.checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(self.checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5) alpha:0.0 animated:animated];
        }
    }
}

- (void)dealloc
{
    self.checkImageView = nil;
}


- (void) setChecked:(BOOL)checked
{
    if (checked)
    {
        self.checkImageView.image = [UIImage imageNamed:@"选中"];
    }
    else
    {
        self.checkImageView.image = [UIImage imageNamed:@"未选"];
    }
    _checked = checked;
}


@end
