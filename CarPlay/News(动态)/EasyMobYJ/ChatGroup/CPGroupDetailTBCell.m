//
//  CPGroupDetailTBCell.m
//  CarPlay
//
//  Created by jiang on 15/10/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPGroupDetailTBCell.h"

@implementation CPGroupDetailTBCell


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
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+10, 17, 120, 16);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = UIColorFromRGB(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        _sexView = [[CPSexView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headIV.frame)+10, CGRectGetMaxY(_nameLabel.frame)+10, 45, 17)];
        [self.contentView addSubview:_sexView];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.frame = CGRectMake(CGRectGetMaxX(_sexView.frame)+10, CGRectGetMaxY(_nameLabel.frame)+14, 80, 9);
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = UIColorFromRGB(0x999999);
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_distanceLabel];
        
        //邀请
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.frame = CGRectMake(kDeviceWidth-15-65, 20, 65, 30);
        _inviteBtn.backgroundColor = UIColorFromRGB(0x74ced6);
        [_inviteBtn setFont:[UIFont systemFontOfSize:12]];
        _inviteBtn.layer.cornerRadius = 15;
        [_inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
        [self.contentView addSubview:_inviteBtn];
        _inviteBtn.tag = 1;
        [_inviteBtn addTarget:self action:@selector(inviteSomeone:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //打电话
        _TelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _TelBtn.frame = CGRectMake(kDeviceWidth-18-15, 25, 15, 20);
        _TelBtn.backgroundColor = [UIColor clearColor];
        _TelBtn.tag = 3;
        [_TelBtn setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [self.contentView addSubview:_TelBtn];
        _TelBtn.hidden  = YES;
        [_TelBtn addTarget:self action:@selector(inviteSomeone:) forControlEvents:UIControlEventTouchUpInside];

        
        //发消息
        _SendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _SendMessageBtn.frame = CGRectMake(CGRectGetMinX(_TelBtn.frame)-10-30, 25, 20, 20);
        _SendMessageBtn.backgroundColor = [UIColor clearColor];
        _SendMessageBtn.tag  = 2;
        [_SendMessageBtn setBackgroundImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
//        _SendMessageBtn.layer.cornerRadius = 30;
//        [_SendMessageBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
        [self.contentView addSubview:_SendMessageBtn];
        _SendMessageBtn.hidden = YES;
        [_SendMessageBtn addTarget:self action:@selector(inviteSomeone:) forControlEvents:UIControlEventTouchUpInside];

        
        
        
        
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, kDeviceWidth, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:lineView];
        lineView.alpha = 0.7;
    }
    return self;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setClipsToBounds:YES];

}
- (void)awakeFromNib {
    // Initialization code
}
- (void)inviteSomeone:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(groupDetailButton:)]) {
        [_delegate groupDetailButton:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
