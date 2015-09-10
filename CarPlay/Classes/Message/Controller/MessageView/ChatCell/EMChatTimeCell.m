/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMChatTimeCell.h"

@implementation EMChatTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        self.backgroundColor = [UIColor clearColor];
        self.timeLabel.backgroundColor = [Tools getColor:@"e6e6e6"];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [Tools getColor:@"ffffff"];
        self.timeLabel.layer.cornerRadius = 9.5;
        self.timeLabel.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.timeLabel sizeToFit];
    self.timeLabel.width += 20;
    self.timeLabel.height = 19;
    self.timeLabel.centerX = self.middleX;
    self.timeLabel.y = self.middleY;
}
@end
