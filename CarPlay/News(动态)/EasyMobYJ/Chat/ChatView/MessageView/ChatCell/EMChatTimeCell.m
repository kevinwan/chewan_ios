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
        // 18 height
    }
    self.backgroundColor = [UIColor clearColor];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.backgroundColor = UIColorFromRGB(0xcccccc);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.timeLabel setNumberOfLines:0];
    [self.contentView addSubview:_timeLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//cell 高度42
-(void)layoutSubviews
{
    UIFont *font = [UIFont systemFontOfSize:10];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [self.timeLabel.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    self.timeLabel.frame = CGRectMake(0.0, 2.0, labelsize.width+20, 18 );
    self.timeLabel.centerX = kDeviceWidth/2;
    self.timeLabel.layer.cornerRadius =9;
    [self.timeLabel.layer setMasksToBounds:YES];

    [super layoutSubviews];
    
}
@end
