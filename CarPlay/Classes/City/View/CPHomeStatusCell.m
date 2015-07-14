//
//  CPHomeStatusCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeStatusCell.h"
#import "UIImageView+WebCache.h"
#import "CPHomeUser.h"
#import "CPHomeStatus.h"


@interface CPHomeStatusCell()


// 头像
@property (weak, nonatomic) IBOutlet UIImageView *photo;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;

// 年龄
@property (weak, nonatomic) IBOutlet UILabel *age;

// 性别
@property (weak, nonatomic) IBOutlet UIImageView *gender;

// 车标
@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogo;

// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *publishTime;

// 付费方式
@property (weak, nonatomic) IBOutlet UILabel *pay;

// 正文
@property (weak, nonatomic) IBOutlet UILabel *introduction;

@end

@implementation CPHomeStatusCell

- (void)awakeFromNib {
    // Initialization code
}


+ (NSString *)identifier{
    return @"CPHomeCell";
}


- (void)setStatus:(CPHomeStatus *)status{
    
    _status = status;
    
    CPHomeUser *user = _status.organizer;
    
    // 头像
    // 头像切圆
    self.photo.layer.cornerRadius = 25;
    self.photo.layer.masksToBounds = YES;
    NSURL *urlPhoto = [NSURL URLWithString:user.photo];
    [self.photo sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    // 昵称
    self.nickname.text = user.nickname;
    
    // 年龄
    self.age.text = user.age;
    
    // 性别
    NSURL *urlGender = [NSURL URLWithString:user.gender];
    [self.gender sd_setImageWithURL:urlGender placeholderImage:[UIImage imageNamed:@""]];
    
    // 车标
    NSURL *urlCarBrandLogo = [NSURL URLWithString:user.carBrandLogo];
    [self.carBrandLogo sd_setImageWithURL:urlCarBrandLogo placeholderImage:[UIImage imageNamed:@""]];
    
    
    // 发布时间
    
    // 付费方式
    self.pay.text = _status.pay;
    
    // 正文
    self.introduction.text = _status.introduction;
    
    
}


@end
