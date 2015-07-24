//
//  CPDiscussCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/24.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPDiscussCell.h"


@interface CPDiscussCell()
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UIButton *genderAndAge;

@property (weak, nonatomic) IBOutlet UILabel *publishTime;

@property (weak, nonatomic) IBOutlet UILabel *introduction;


@end

@implementation CPDiscussCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
