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
static CGFloat const kBounceValue = 20.0f;
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
    self.carName.minimumFontSize = 10;
    [self setupButton:@[self.seatMain,self.seatone, self.seatTwo,self.seatThree]];
  
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
    [self removeImageOfButton:@[self.seatMain,self.seatone, self.seatTwo,self.seatThree]];
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
    switch ([self.totalSeat intValue]) {
        case 2:
            self.seatThree.hidden  = YES;
            self.seatTwo.hidden = YES;
            break;
        case 3:
            self.seatThree.hidden  = YES;
            break;
        default:
            break;
    }
    //显示座位的头像
    NSArray *userArray = _models.users;
    for (users *user in userArray) {
        if ([user.seatIndex intValue] < 4) {
            switch ([user.seatIndex intValue]) {
                case 0:
                    [self.seatMain sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    break;
                case 1:
                    [self.seatone sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    break;
                case 2:
                    [self.seatTwo sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    break;
                case 3:
                    [self.seatThree sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    break;
                default:
                    break;
            }
        } 
    }
        [self getBackImageOfButton:@[self.seatMain,self.seatone, self.seatTwo,self.seatThree]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
