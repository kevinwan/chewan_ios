//
//  memberCell.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/15.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "memberCell.h"
#import "AppAppearance.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface memberCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *carLogImageView;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleLabelX;




@end

@implementation memberCell

- (void)awakeFromNib {
    
    self.titleLabel.font = [AppAppearance textLargeFont];
    self.titleLabel.textColor = [AppAppearance textDarkColor];
    self.subTitleLabel.font = [AppAppearance textMediumFont];
    self.subTitleLabel.textColor = [AppAppearance textMediumColor];
    self.memberIconImageView.layer.cornerRadius = 25;
    self.memberIconImageView.clipsToBounds = YES;
    
}
- (void)setModels:(members *)models {
    _models = models;
    self.titleLabel.text = _models.nickname;
    [self.memberIconImageView sd_setImageWithURL:[NSURL URLWithString:_models.photo]];
    [self.carLogImageView sd_setImageWithURL:[NSURL URLWithString:_models.carBrandLogo]];
    [self.ageButton setTitle:[NSString stringWithFormat:@"%@",_models.age] forState:UIControlStateNormal];
    UIImage *ageimage = nil;
    if ([_models.gender isEqualToString:@"男"]) {
        ageimage = [UIImage imageNamed:@"member_man"];
    } else {
        ageimage = [UIImage imageNamed:@"member_women"];
    }
    [self.ageButton setBackgroundImage:ageimage forState:UIControlStateNormal];
    self.ageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.ageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    [self.carLogImageView sd_setImageWithURL:[NSURL URLWithString:_models.carBrandLogo]];
    //将2个两个字变红
    if (_models.carModel.length == 0) {
        self.subTitleLabel.text = @"带我飞~";
        self.subTitleLabelX.constant = -14;
    } else if (![_models.seat isEqualToString:@"0"]){
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,%@年驾龄,提供%@个座位",_models.carModel, _models.drivingExperience,_models.seat]];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[AppAppearance redColor] range:NSMakeRange(subTitle.length - 4, 2)];
        self.subTitleLabel.attributedText = subTitle;
        self.subTitleLabelX.constant = 7;
    } else {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,%@年驾龄",_models.carModel, _models.drivingExperience]];
        self.subTitleLabel.attributedText = subTitle;
        self.subTitleLabelX.constant = 7;
    
    }
  
   
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
