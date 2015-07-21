/*
 **************************************************************************************
 * Copyright (C) 2013年 南京价公信息技术有限公司 . All Rights Reserved.
 *
 * Project      : EquityPrice
 *
 * File			: CustomBrandCell.m
 *
 * Description	: 
 *
 * Record		: ミ﹏糖寅╰☆
 *
 * History		: Inspiration 13-11-19 Created This File.
 **************************************************************************************
 **/

#import "CustomBrandCell.h"

@implementation CustomBrandCell

+ (CGFloat)standardHeight
{
    return 44.0f;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}


- (void)initViews
{
    self.backgroundColor = [UIColor whiteColor];

    self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 30.0f, 30.0f)];
    _thumbnailView.backgroundColor = [UIColor clearColor];
    _thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_thumbnailView];
    
    self.brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_thumbnailView.right +11 , 8, kScreenWidth - _thumbnailView.width - 11, _thumbnailView.height)];

//    _brandNameLabel.font = [AppAppearance textMediumFont];
    _brandNameLabel.textAlignment = NSTextAlignmentLeft;
//    self.brandNameLabel.textColor = [AppAppearance textDarkColor];
    [self.contentView addSubview:_brandNameLabel];
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
