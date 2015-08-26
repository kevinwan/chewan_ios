//
//  carCell.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/14.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "carManageCell.h"
#import "AppAppearance.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "users.h"
@interface carManageCell () 
@property (weak, nonatomic) IBOutlet UIImageView *carLog;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogX;
@end

@implementation carManageCell

- (void)awakeFromNib {
    self.carName.font = [AppAppearance textLargeFont];
    self.carName.textColor = [AppAppearance textDarkColor];
    self.carName.preferredMaxLayoutWidth = 70;
    self.carName.adjustsFontSizeToFitWidth = YES;
    
}
//button需要设置imageView才美观
- (void)setupButton:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        button.imageView.layer.cornerRadius = 12;
        [button clipsToBounds];
        button.imageEdgeInsets = UIEdgeInsetsMake(-4, 3, 10, 3);
    }
}
- (void)removeImageOfButton:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        [button setImage:nil forState:UIControlStateNormal];
    }
}
- (void)getBackImageOfButton:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        if ([button imageForState:UIControlStateNormal]) {
            [button setBackgroundImage:[UIImage imageNamed:@"member_mainSeat"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"member_seat"] forState:UIControlStateNormal];
        }
        
    }
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
    self.carName.text = [NSString stringWithFormat:@"%@",_models.carModel];
    self.totalSeat = _models.totalSeat;
}
@end
