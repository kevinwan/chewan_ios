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

@interface CPActivityApplyCell()

@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipmsgLabel;

@property (weak, nonatomic) IBOutlet CPSexView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *carView;
@property (weak, nonatomic) IBOutlet UILabel *offerSeatLabel;
@property (weak, nonatomic) IBOutlet CPActivityApplyButton *agreeBtn;

@end

@implementation CPActivityApplyCell

- (void)awakeFromNib {
    
    
}

/**
 *  设置提供座位的label的text
 */
- (NSAttributedString *)seatLabelText:(NSString *)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"提供"];
    NSMutableAttributedString *seat = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fc6e51"]}];
    [str appendAttributedString:seat];
    NSAttributedString *zuo = [[NSAttributedString alloc] initWithString:@"座位"];
    [str appendAttributedString:zuo];
    return str;
}

- (void)setModel:(CPActivityApplyModel *)model
{
    _model = model;
    
    if (model.photo) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.photo] forState:UIControlStateNormal placeholderImage:nil];
    }else{
        [self.iconView setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    }
    
    if (model.nickname) {
        self.nameLabel.text = model.nickname;
    }else{
        self.nameLabel.text = @"";
    }
    
    if (model.age && model.gender) {
        self.sexView.isMan = [model.gender isEqualToString:@"男"];
        [self.sexView setTitle:[NSString stringWithFormat:@"%zd",[model.age intValue]] forState:UIControlStateNormal];
    }
    
    self.tipmsgLabel.text = model.title;
    
    if (model.carBrandLogo) {
        self.carView.hidden = NO;
        [self.carView sd_setImageWithURL:[NSURL URLWithString:model.carBrandLogo] placeholderImage:nil];
    }else{
        self.carView.hidden = YES;
    }
    
    if ([model.seat intValue]) {
        
        self.offerSeatLabel.attributedText = [self seatLabelText:[NSString stringWithFormat:@"%zd",[model.seat intValue]]];
    }else{
        self.offerSeatLabel.text = @"";
    }
    
    if ([model.status isEqualToString:@"已同意"]) {
        self.agreeBtn.selected = YES;
    }else{
        self.agreeBtn.selected  = NO;
    }
    
}
- (IBAction)agreeBtnClick:(id)sender {
    
    [CPNotificationCenter postNotificationName:@"AgreeApply" object:nil userInfo:@{@"appid" : _model.applicationId}];
}


@end
