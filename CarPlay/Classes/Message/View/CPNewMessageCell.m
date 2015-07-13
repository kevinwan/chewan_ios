//
//  CPNewMessageCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNewMessageCell.h"

@interface CPNewMessageCell()

// 显示图像的区域
@property (weak, nonatomic) IBOutlet UIButton *iconView;
// 显示姓名的label
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
// 显示性别的区域
@property (weak, nonatomic) IBOutlet UIButton *sexView;
// 用户描述的label
@property (weak, nonatomic) IBOutlet UILabel *descripteLable;

@end

@implementation CPNewMessageCell

- (void)awakeFromNib {
    self.nameLable.text = [NSString stringWithFormat:@"我是%zd号👌👌👌",arc4random_uniform(100)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
