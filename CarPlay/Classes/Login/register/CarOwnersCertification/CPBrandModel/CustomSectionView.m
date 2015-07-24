/*
 **************************************************************************************
 * Copyright (C) 2013年 南京价公信息技术有限公司 . All Rights Reserved.
 *
 * Project      : EquityPrice
 *
 * File			: CustomSectionView.m
 *
 * Description	: 
 *
 * Record		: ミ﹏糖寅╰☆
 *
 * History		: Inspiration 13-11-21 Created This File.
 **************************************************************************************
 **/

#import "CustomSectionView.h"

@interface CustomSectionView ()

@property (nonatomic ,strong) UIImageView *brandImage;

@property (nonatomic ,strong) UILabel *brandLabel;

@end

@implementation CustomSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.brandImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, 12.0f, 30.0f, 30.0f)];
        _brandImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_brandImage];
        
        self.brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(_brandImage.right + 10.0f, 0.0f, 300.0f, frame.size.height)];
        _brandLabel.backgroundColor = [UIColor clearColor];
        _brandLabel.font = [UIFont systemFontOfSize:16.0f];
//        _brandLabel.textColor = [AppAppearance textMediumColor];
        [self addSubview:_brandLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12.0f, frame.size.height - 0.5f, frame.size.width, 0.5f)];
//        lineView.backgroundColor = [AppAppearance backgroundColor];
        [self addSubview:lineView];
    }
    
    return self;
}


- (void)setImageName:(NSString *)imageName
{
    if (imageName != _imageName) {
        _imageName = imageName;
//        [_brandImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kImageHost, [Interface brandModelLogoImageLink], _imageName]] placeholderImage:nil];
        [_brandImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageName]]];
        
    }
}


- (void)setCarName:(NSString *)CarName
{
    if (CarName != _CarName) {
        _CarName = CarName;
        _brandLabel.text = _CarName;
    }
}

@end
