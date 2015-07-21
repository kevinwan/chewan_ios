/*
 **************************************************************************************
 * Copyright (C) 2013年 南京价公信息技术有限公司 . All Rights Reserved.
 *
 * Project      : EquityPrice
 *
 * File			: CustomSlideCell.m
 *
 * Description	: 
 *
 * Record		: ミ﹏糖寅╰☆
 *
 * History		: Inspiration 13-11-21 Created This File.
 **************************************************************************************
 **/

#import "CustomSlideCell.h"

@implementation CustomSlideCell

+ (CGFloat)standardHeight
{
    return 40.0f;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.carNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 120-12-5, [CustomSlideCell standardHeight])];
        _carNameLabel.backgroundColor = [UIColor clearColor];
//        _carNameLabel.font = [AppAppearance textMediumFont];
//        _carNameLabel.textColor = [AppAppearance textDarkColor];
        _carNameLabel.numberOfLines = 0;
        [self.contentView addSubview:_carNameLabel];
    }
    return self;
}

@end
