//
//  CPHomeIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeIconCell.h"
#import "CPHomeMember.h"
#import "UIImageView+WebCache.h"

@interface CPHomeIconCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation CPHomeIconCell
// 获取当前cell重用标示符
+ (NSString *)identifier{
    return @"homeMemCell";
}

- (void)setHomeMember:(CPHomeMember *)homeMember{
    _homeMember = homeMember;
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:_homeMember.photo];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    // 判断如果头像超过4个，第五个头像就显示数字
    if (_homeMember.membersCount > 4 && _homeMember.currentMember == 4) {
      
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.backgroundColor = [UIColor grayColor];
        NSString *iconCount = [NSString stringWithFormat:@"%@",@(_homeMember.membersCount)];
        [btn setTitle:iconCount forState:UIControlStateNormal];
        [self.iconView addSubview:btn];
        
        // 添加按钮后取出头像图片
        self.iconView.image = [UIImage imageNamed:@"用户小头像底片"];
    }
    
    
}

@end
