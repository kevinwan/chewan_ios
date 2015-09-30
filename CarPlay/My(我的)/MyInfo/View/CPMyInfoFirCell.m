//
//  CPMyInfoFirCell.m
//  CarPlay
//
//  Created by 公平价 on 15/9/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoFirCell.h"

@implementation CPMyInfoFirCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *firId = @"myInfoFirCell";
    CPMyInfoFirCell *cell = [tableView dequeueReusableCellWithIdentifier:firId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoFirCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
