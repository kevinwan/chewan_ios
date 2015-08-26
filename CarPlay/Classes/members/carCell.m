//
//  carCell.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/14.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "carCell.h"
#import "AppAppearance.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "users.h"
@interface carCell () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *carLog;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogX;

@end

@implementation carCell

- (void)awakeFromNib {
    self.carName.textColor = [AppAppearance textDarkColor];
    self.carName.preferredMaxLayoutWidth = 70;
    self.carName.adjustsFontSizeToFitWidth = YES;
  
}

- (void)setModels:(cars *)models {
    _models = models;
    //设置初始座位头像图片为nil
    NSURL *url = [NSURL URLWithString:_models.carBrandLogo];
    if (_models.carBrandLogo.length) {
        [self.carLog sd_setImageWithURL:url];
        self.carLogH.constant = 25;
        self.carLogW.constant = 25;
        self.carLogX.constant = 10;
    } else {
        self.carLog.image = [UIImage imageNamed:@"默认车型"];
        self.carLogH.constant = 22;
        self.carLogW.constant = 37;
        self.carLogX.constant = 25;
    }
   
    NSString * carNameText = [NSString stringWithFormat:@"%@",_models.carModel];
    self.carName.text = carNameText;
    self.totalSeat = _models.totalSeat;
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
