//
//  CPSubscribeCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSubscribeCell.h"
#import "CPCancleSubBtn.h"
#import "CPSexView.h"
#import "UIButton+WebCache.h"
#import "CPMySubscribeModel.h"

@interface CPSubscribeCell()
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet CPSexView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carLogoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogoWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelXConstrant;

@end

@implementation CPSubscribeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CPOrganizer *)model
{
    _model = model;
    
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:model.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    self.nameLbl.text = model.nickname;
    
    self.sexView.isMan = model.isMan;
    self.sexView.age = model.age;
    
    if (model.carBrandLogo){
        [self.carLogoView sd_setImageWithURL:[NSURL URLWithString:model.carBrandLogo]];
        self.carLogoWitdh.constant = 15;
        self.descLabelXConstrant.constant = 30;
    }else{
        self.carLogoWitdh.constant = 0;
        self.descLabelXConstrant.constant = 10;
        
    }
    
    self.descLabel.text = model.descStr;
    
    
}
- (IBAction)cancleSubscribeClick:(UIButton *)sender
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/unlisten?token=%@",userId, token];
    [SVProgressHUD showWithStatus:@"取消关注中"];
    [ZYNetWorkTool postJsonWithUrl:url params:@{@"targetUserId" : self.model.userId} success:^(id responseObject) {
        if (CPSuccess) {
            [CPNotificationCenter postNotificationName:CPCancleSubscribeNotify object:nil userInfo:@{CPCancleSubscribeInfo : @(self.row)}];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"取消失败"];
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
