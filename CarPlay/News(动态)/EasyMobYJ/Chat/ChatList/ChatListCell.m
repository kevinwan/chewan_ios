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


#import "ChatListCell.h"
#import "UIImageView+HeadImage.h"
#import "NSString+Extend.h"
@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_detailLabel;
    UILabel *_unreadLabel;
    UIView *_lineView;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-75-10, 7, 75, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_timeLabel setTextColor:UIColorFromRGB(0xaaaaaa)];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(45-5, 5, 17, 17)];
        _unreadLabel.backgroundColor = UIColorFromRGB(0xfe5969);
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 8.5;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 31.5, 175, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        //显示性别年龄
        self.cpSexView = [[CPSexView alloc]initWithFrame:CGRectMake(68, 7, 45, 17)];
        [self.contentView addSubview:_cpSexView];
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kDeviceWidth, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xefefef);
        
        //感兴趣的模块  需要显示头像
        ///
        _interestIV = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-40-10, 10, 40, 40)];
        _interestIV.backgroundColor =[UIColor clearColor];
        [_interestIV setClipsToBounds:YES];
        _interestIV.layer.cornerRadius= 20;
        [self.contentView addSubview:_interestIV];
        
        _HeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 45, 45)];
        _HeadIV.backgroundColor = [UIColor clearColor];
        _HeadIV.layer.cornerRadius = 22.5;
        [_HeadIV setClipsToBounds:YES];
        [self.contentView addSubview:_HeadIV];
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = UIColorFromRGB(0xfe5969);
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = UIColorFromRGB(0xfe5969);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    
//    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
////    [self.imageView sd_setImageWithURL:_imageURL];
////    [self.imageView imageWithUsername:_name placeholderImage:_placeholderImage];
//    self.imageView.frame = CGRectMake(10, 7, 45, 45);
//    
//    [self.imageView setClipsToBounds:YES];
//    self.imageView.layer.cornerRadius = 22;
//    self.textLabel.text = _name;
//    [self.textLabel setTextWithUsername:_name];
    
    CGSize size =  [self.textLabel.text sizeWithFont:self.textLabel.font maxW:200];
    NSLog(@"size = %@",NSStringFromCGSize(size));
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(_HeadIV.frame)+10, 8.5, 175, 20);
//    _cpSexView.frame = CGRectMake(68, 7, 45, 17);
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0 && !_isGroup) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        _unreadLabel.frame =CGRectMake(45-5, 5, 17, 17);
        _unreadLabel.layer.cornerRadius = 8.5;

        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else if (_unreadCount >0 && _isGroup){
        
        _unreadLabel.frame = CGRectMake(43, 7, 11, 11);
        _unreadLabel.layer.cornerRadius = 5.5;
        _unreadLabel.hidden = NO;
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = @"";

    }
    else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    _lineView.frame = frame;
}

-(void)setName:(NSString *)name{
    _name = name;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
