//
//  CPDiscussCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/24.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPDiscussCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


@interface CPDiscussCell()

// 头像
//@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UIButton *photo;

- (IBAction)photoClick;


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
    [self.photo sd_setImageWithURL:photoUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
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
    if (discussStatus.replyUserName != nil && ![discussStatus.replyUserName isEqualToString:@""]) {
        
        
        // 设置"回复"字体颜色
        NSMutableAttributedString *replyFont = [[NSMutableAttributedString alloc] initWithString:@"回复" attributes:@{NSForegroundColorAttributeName:[Tools getColor:@"434A54"]}];
        
        // 设置被回复人昵称的颜色
        NSAttributedString *nicknameFont = [[NSAttributedString alloc] initWithString:discussStatus.replyUserName attributes:@{NSForegroundColorAttributeName:[Tools getColor:@"5d9beb"]}];
        
        // 设置回复内容颜色
        NSAttributedString *commentFont = [[NSAttributedString alloc] initWithString:discussStatus.comment attributes:@{NSForegroundColorAttributeName:[Tools getColor:@"434A54"]}];
        
        // 设置冒号
        NSAttributedString *font = [[NSAttributedString alloc] initWithString:@"：" attributes:@{NSForegroundColorAttributeName:[Tools getColor:@"434A54"]}];
        
        [replyFont appendAttributedString:nicknameFont];
        [replyFont appendAttributedString:font];
        [replyFont appendAttributedString:commentFont];
        [self.comment setAttributedText:replyFont];
    }else{
        self.comment.text = discussStatus.comment;
    }
    
  
}


- (CGFloat)cellHeightWithDiscussStatus:(CPDiscussStatus *)discussStatus{
    
    // 设置数据，便于系统内部计算尺寸
    self.discussStatus = discussStatus;
    
    // 强制更新布局
    [self layoutIfNeeded];
    
    // 返回cell高度，cell的高度就是底部头像列表的最大高度
    return CGRectGetMaxY(self.comment.frame) + 10;
    
}


- (IBAction)photoClick {
    // 判断是否已登录
    if (!CPUnLogin) {
        
        // 已登录通知控制器跳到他的详情页面
        if (self.goTaDetails != nil) {
            self.goTaDetails();
        }
    }else{
        
        // 未登录跳到登录页面
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
}
@end
