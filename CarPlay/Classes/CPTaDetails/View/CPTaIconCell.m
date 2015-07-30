//
//  CPTaIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaIconCell.h"
#import "UIImageView+WebCache.h"

@interface CPTaIconCell ()

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation CPTaIconCell

+ (NSString *)identifier{
    return @"taIconCell";
}

- (void)setTaMember:(CPTaMember *)taMember{
    _taMember = taMember;
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:taMember.photo];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
}

@end
