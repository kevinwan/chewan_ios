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
#import "ZYExtension.h"
@implementation CustomBrandCell

+ (CGFloat)standardHeight
{
    return 52.0f;
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

    self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 11.0f, 30.0f, 30.0f)];
    _thumbnailView.backgroundColor = [UIColor clearColor];
    _thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_thumbnailView];

    self.brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.thumbnailView.frame) + 11 , 12, ZYScreenWidth - _thumbnailView.width - 11, _thumbnailView.height)];

    _brandNameLabel.font = [UIFont systemFontOfSize:16.0f];
    _brandNameLabel.textAlignment = NSTextAlignmentLeft;
    self.brandNameLabel.textColor = [Tools getColor:@"434a53"];
    [self.contentView addSubview:_brandNameLabel];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 51.5, ZYScreenWidth, .5)];
    line.backgroundColor = [Tools getColor:@"e6e9ed"];
    [self.contentView addSubview:line];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
