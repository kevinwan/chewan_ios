/*
 **************************************************************************************
 * Copyright (C) 2013年 南京价公信息技术有限公司 . All Rights Reserved.
 *
 * Project      : EquityPrice
 *
 * File			: CustomBrandCell.h
 *
 * Description	: 
 *
 * Record		: ミ﹏糖寅╰☆
 *
 * History		: Inspiration 13-11-19 Created This File.
 **************************************************************************************
 **/

#import <UIKit/UIKit.h>

@interface CustomBrandCell : ZYTableViewCell

+ (CGFloat)standardHeight;

/*!
 @property
 @abstract 缩略图
 */
@property (nonatomic, strong) UIImageView *thumbnailView;

/*!
 @property
 @abstract 品牌名称标签
 */
@property (nonatomic, strong) UILabel *brandNameLabel;

@end
