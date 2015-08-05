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

- (void)setModel:(CPActivityApplyModel *)model
{
    _model = model;
    
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
        self.tipMsgLabelWidth.constant = kScreenWidth -  135;
        if (model.carBrandLogo.length) {
            DLog(@"%@]]]]",model.seatText);
            self.offerSeatLabel.attributedText = model.seatText;
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
    
    
    NSString *url = [NSString stringWithFormat:@"v1/application/%@/process",_model.activityId];
    DLog(@"%@---",url);
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[@"action"] = @"1";
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool postJsonWithUrl:url params:json success:^(id responseObject) {
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            [CPNotificationCenter postNotificationName:CPActivityApplyNotification object:nil userInfo:@{CPActivityApplyInfo :@(self.row)}];
            _model.isAgree = YES;
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

@end
