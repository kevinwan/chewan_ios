/*
 **************************************************************************************
 * Copyright (C) 2013年 南京价公信息技术有限公司 . All Rights Reserved.
 *
 * Project      : EquityPrice
 *
 * File			: CustomSlideCell.h
 *
 * Description	: 
 *
 * Record		: ミ﹏糖寅╰☆
 *
 * History		: Inspiration 13-11-21 Created This File.
 **************************************************************************************
 **/

#import <UIKit/UIKit.h>

@interface CustomSlideCell : UITableViewCell

+ (CGFloat)standardHeight;

@property (nonatomic , strong)UIImageView *picImage;

@property (nonatomic , strong)UILabel *carNameLabel;

@end
