//
//  CPMyCareCell.m
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyCareCell.h"
#import "UIButton+WebCache.h"
#import "CPSexView.h"

@interface CPMyCareCell ()

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;

// 性别和年龄
@property (weak, nonatomic) IBOutlet CPSexView *genderAndAge;

// 距离
@property (weak, nonatomic) IBOutlet UILabel *distance;
//头像认证状态
@property (weak, nonatomic) IBOutlet UIImageView *photoAuthStatus;

//车主认证状态
@property (weak, nonatomic) IBOutlet UIImageView *licenseAuthStatus;

//昵称Label宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameWidth;

@end

@implementation CPMyCareCell

- (void)awakeFromNib {
    
}


+ (NSString *)identifier{
    return @"myCareCell";
}


- (IBAction)iconViewClick:(id)sender {
    
    [self superViewWillRecive:CPMyCareIconViewClickKey info:_careUser];
}

- (void)setCareUser:(CPCareUser *)careUser{
    _careUser = careUser;
    
    // 设置头像
    self.avatar.layer.cornerRadius = 25;
    self.avatar.layer.masksToBounds = YES;
    
    NSURL *imageUrl = [NSURL URLWithString:careUser.avatar];
    [self.avatar sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:nil];
    
    
    // 设置昵称
    self.nickname.text = careUser.nickname;
    //设置昵称长度
    if (ZYScreenWidth == 320) {
        [self.nickname setFont:ZYFont14];
        self.nickNameWidth.constant = [careUser.nickname sizeWithFont:ZYFont14].width;
    }else
        self.nickNameWidth.constant = [careUser.nickname sizeWithFont:ZYFont16].width;
    
    //判断头像认证和车主认证状态
    if ([careUser.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.photoAuthStatus setHidden:NO];
    }
    
    if ([careUser.licenseAuthStatus isEqualToString:@"认证通过"]) {
        [self.licenseAuthStatus setHidden:NO];
        [self.licenseAuthStatus zySetImageWithUrl:careUser.car.logo placeholderImage:nil];
    }
    
    // 设置性别和年龄
    if ([careUser.gender isEqualToString:@"男"]) {
            self.genderAndAge.isMan = YES;
    }else{
        self.genderAndAge.isMan = NO;
    }
    
    self.genderAndAge.age = careUser.age;
    
    // 设置距离
    if (careUser.distance >= 1000) {
        CGFloat dis = careUser.distance / 1000.0;
        self.distance.text = [NSString stringWithFormat:@"%.1fkm",dis];
    }else{
        self.distance.text = [NSString stringWithFormat:@"%zdm",careUser.distance];
    }
//    [self.avatar addTarget:self.su action:@selector(taInfo:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
