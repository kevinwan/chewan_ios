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
