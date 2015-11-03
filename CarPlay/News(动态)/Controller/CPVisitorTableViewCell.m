//
//  CPVisitorTableViewCell.m
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPVisitorTableViewCell.h"

@implementation CPVisitorTableViewCell

//高度 70
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 , 50, 50)];
        _headIV.backgroundColor = [UIColor clearColor];
        _headIV.layer.cornerRadius = 25;
        [_headIV.layer setMasksToBounds:YES];
        [self.contentView addSubview:_headIV];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+10, 17, 60, 16);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+10, 5+CGRectGetMaxY(_nameLabel.frame), 60, 16);
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = UIColorFromRGB(0x999999);
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_messageLabel];

        
        _sexView = [[CPSexView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+5, 17, 45, 17)];
        [self.contentView addSubview:_sexView];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(kDeviceWidth-10-80, 21, 80, 9);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.frame = CGRectMake(kDeviceWidth-10-60, CGRectGetMaxY(_timeLabel.frame)+15, 60, 9);
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = [UIColor grayColor];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_distanceLabel];
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, kDeviceWidth, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xefefef);
        [self.contentView addSubview:lineView];
        
        UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
        aView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        self.selectedBackgroundView = aView;
    }
    return self;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
