//
//  CPDiscussCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/24.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPDiscussCell.h"
#import "UIImageView+WebCache.h"


@interface CPDiscussCell()

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *photo;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;

// 性别和年龄
@property (weak, nonatomic) IBOutlet UIButton *genderAndAge;

// 发表时间
@property (weak, nonatomic) IBOutlet UILabel *publishTime;

// 正文
@property (weak, nonatomic) IBOutlet UILabel *comment;



@end

@implementation CPDiscussCell

- (void)awakeFromNib{
    
    // 设置正文最大的宽度
    self.comment.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 75;
}

+ (NSString *)identifier{
    return @"discussCell";
}


- (void)setDiscussStatus:(CPDiscussStatus *)discussStatus{
    
    _discussStatus = discussStatus;
    
    // 头像
    self.photo.layer.cornerRadius = 12.5;
    self.photo.layer.masksToBounds = YES;
    
    NSURL *photoUrl = [NSURL URLWithString:_discussStatus.photo];
    [self.photo sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    // 昵称
    self.nickname.text = _discussStatus.nickname;

    // 年龄
    [self.genderAndAge setTitle:_discussStatus.age forState:UIControlStateNormal];
    
    
    // 性别
    if ([_discussStatus.gender isEqualToString:@"男"]) {
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"男-1"] forState:UIControlStateNormal];
    }else{
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"女-1"] forState:UIControlStateNormal];
    }

    
    // 发表时间
    self.publishTime.text = _discussStatus.publishTimeStr;
    
    // 正文
    self.comment.text = _discussStatus.comment;
  
}


- (CGFloat)cellHeightWithDiscussStatus:(CPDiscussStatus *)discussStatus{
    
    // 设置数据，便于系统内部计算尺寸
    self.discussStatus = discussStatus;
    
    // 强制更新布局
    [self layoutIfNeeded];
    
    // 返回cell高度，cell的高度就是底部头像列表的最大高度
    return CGRectGetMaxY(self.comment.frame);
    
}


@end
