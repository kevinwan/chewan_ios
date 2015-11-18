//
//  CareMeTableViewCell.m
//  CarPlay
//
//  Created by jiang on 15/10/22.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CareMeTableViewCell.h"

@implementation CareMeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
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
        _phohtAuthIV = [[UIImageView alloc] initWithFrame:CGRectMake(10+50-15, 10+50-18 , 18, 18)];
        _phohtAuthIV.backgroundColor = [UIColor clearColor];
        _phohtAuthIV.layer.cornerRadius = 9;
        _phohtAuthIV.image = [UIImage imageNamed:@"photo_auto_yes"];
        [_phohtAuthIV.layer setMasksToBounds:YES];
        [self.contentView addSubview:_phohtAuthIV];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headIV.frame)+10, 27, 60, 16);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        _sexView = [[CPSexView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+5, 27, 45, 17)];
        [self.contentView addSubview:_sexView];
        _carAuthIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sexView.frame), 27, 18, 18)];
        _carAuthIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_carAuthIV];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(kDeviceWidth-10-80, 20, 80, 9);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = UIColorFromRGB(0xaaaaaa);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.frame = CGRectMake(kDeviceWidth-10-60, CGRectGetMaxY(_timeLabel.frame)+15, 60, 9);
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = UIColorFromRGB(0xaaaaaa);
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_distanceLabel];
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, kDeviceWidth, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xefefef);
        [self.contentView addSubview:lineView];
        lineView.alpha = 0.7;
        
        
        _selectdView = [[UIView alloc] initWithFrame:self.contentView.frame];
        _selectdView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.selectedBackgroundView = _selectdView;
    }
    return self;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [self.nameLabel.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    //    self.timeLabel.frame = CGRectMake(0.0, 12.0, labelsize.width+20, 18 );
    _nameLabel.width = labelsize.width;
    _sexView.x = CGRectGetMaxX(_nameLabel.frame)+10;
    _carAuthIV.x = CGRectGetMaxX(_sexView.frame)+10;

    _selectdView.frame = self.contentView.frame;

}
@end
