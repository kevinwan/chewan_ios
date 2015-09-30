//
//  CPMyInfoSecCell.m
//  CarPlay
//
//  Created by 公平价 on 15/9/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoSecCell.h"

@implementation CPMyInfoSecCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *secId = @"myInfoSecCell";
    CPMyInfoSecCell *cell = [tableView dequeueReusableCellWithIdentifier:secId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoSecCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
