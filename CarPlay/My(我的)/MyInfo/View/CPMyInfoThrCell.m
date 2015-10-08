//
//  CPMyInfoThrCell.m
//  CarPlay
//
//  Created by 公平价 on 15/9/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoThrCell.h"

@implementation CPMyInfoThrCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ThrId = @"myInfoThrCell";
    CPMyInfoThrCell *cell = [tableView dequeueReusableCellWithIdentifier:ThrId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoThrCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
